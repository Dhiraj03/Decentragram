import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:decentragram/backend/local_datasource.dart';
import 'package:decentragram/core/errors.dart';
import 'package:decentragram/database/firestore_repository.dart';
import 'package:decentragram/models/post_model.dart';
import 'package:decentragram/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class RemoteDataSource {
  var dioClient = Dio();
  static const String maticURL =
      'https://mainnet-api.maticvigil.com/v1.0/contract/';
  static const String contractAddress =
      "0x38fa5194cb8326b6b22d9c627cc76a0134012258";
  String url = maticURL + contractAddress;
  String ipfs = 'https://ipfs.infura.io:5001/api/v0/add?pin=false';
  String apiKey = 'd4fdc5d6-ce7b-4624-ba95-7ba359ca3bdd';
  FirestoreRepository repo = FirestoreRepository();
  LocalDataSource localDataSource = LocalDataSource();

  Future<Either<ErrorMessage, String>> addUser(
      String username, File profileImage) async {
    final Map<String, dynamic> map = {
      'file': await MultipartFile.fromFile(profileImage.path),
    };
    var ipfsHash;
    var ipfsResponse =
        await dioClient.post<dynamic>(ipfs, data: FormData.fromMap(map));
    if (ipfsResponse.statusCode != 200)
      return Left(ErrorMessage(message: ipfsResponse.data.toString()));
    else
      ipfsHash = ipfsResponse.data["Hash"];
    UserModel user = await repo.getUser();
    print(user.userAddress);
    Map<String, dynamic> requestMap = {
      "userAddress": user.userAddress,
      "username": username,
      "dpIpfsHash": ipfsHash
    };
    print("User Address" + user.userAddress);
    print(ipfsHash);
    try {
      var response = await dioClient.post(url + "/createProfile",
          data: requestMap,
          options: Options(headers: {
            "X-API-KEY": [apiKey]
          }, contentType: Headers.formUrlEncodedContentType));
      repo.initialProfileSaved(username);
      return Right(response.data["data"][0]["txHash"]);
    } catch (e) {
      print(e.response);
      return Left(ErrorMessage(message: "Error!"));
    }
  }

  Future<Either<ErrorMessage, String>> publishImagePost(
      String time, File image, String caption, String userAddress) async {
    final Map<String, dynamic> map = {
      'file': await MultipartFile.fromFile(image.path),
    };
    var ipfsHash;
    var ipfsResponse =
        await dioClient.post<dynamic>(ipfs, data: FormData.fromMap(map));
    if (ipfsResponse.statusCode != 200)
      return Left(ErrorMessage(message: ipfsResponse.data.toString()));
    else
      ipfsHash = ipfsResponse.data["Hash"];
    Map<String, dynamic> requestMap = {
      "userAddress": userAddress,
      "ipfsHash": ipfsHash,
      "caption": caption,
      "time": time
    };
    print(requestMap.toString());
    try {
      var response = await dioClient.post(url + "/postImage",
          data: requestMap,
          options: Options(headers: {
            "X-API-KEY": [apiKey]
          }, contentType: Headers.formUrlEncodedContentType));
      print(response.toString());
      return Right(response.data["data"][0]["txHash"]);
    } catch (e) {
      print(e.response);
      print('lmao');
      return Left(ErrorMessage(message: "Error!"));
    }
  }

  Future<Either<ErrorMessage, String>> publishTextPost(
      String time, String text, String caption, String userAddress) async {
    File file = await localDataSource.storeFile(text);
    final Map<String, dynamic> map = {
      'file': await MultipartFile.fromBytes(File(file.path).readAsBytesSync(),
          filename: file.path.split("/").last)
    };
    print(file.readAsStringSync().toString());
    var ipfsHash;
    var ipfsResponse = await dioClient.post<dynamic>(
      ipfs,
      data: FormData.fromMap(map),
    );
    if (ipfsResponse.statusCode != 200)
      return Left(ErrorMessage(message: ipfsResponse.data.toString()));
    else
      ipfsHash = ipfsResponse.data["Hash"];
    Map<String, dynamic> requestMap = {
      "userAddress": userAddress,
      "ipfsHash": ipfsHash,
      "caption": caption,
      "time": time
    };
    try {
      var response = await dioClient.post(url + "/postText",
          data: requestMap,
          options: Options(headers: {
            "X-API-KEY": [apiKey]
          }, contentType: Headers.formUrlEncodedContentType));
      print(response.toString());
      return Right(response.data["data"][0]["txHash"]);
    } catch (e) {
      print(e.response);
      print('lmao');
      return Left(ErrorMessage(message: "Error!"));
    }
  }

  Future<void> followProfile(String userAddress, String followAddress) async {
    Map<String, dynamic> requestMap = {
      "userAddress": userAddress,
      "followAddress": followAddress
    };
    try {
      var response = await dioClient.post(url + "/followProfile",
          data: requestMap,
          options: Options(headers: {
            "X-API-KEY": [apiKey]
          }, contentType: Headers.formUrlEncodedContentType));
      return Right(response.data["data"][0]["txHash"]);
    } catch (e) {
      return Left(ErrorMessage(message: "Error!"));
    }
  }

  Future<bool> doesFollowProfile(
      String userAddress, String followAddress) async {
    print('lol');
    var response =
        await dioClient.get(url + "/doesFollow/$userAddress/$followAddress");
    return response.data["data"][0]["follows"];
  }

  Future<UserModel> getUser(String address) async {
    var response = await dioClient.get(url + "/getUserProfile/$address");
    var ipfsHash = response.data["data"][0]["dpIpfsHash"];
    var image;
    var username = response.data["data"][0]["username"];
    var ipfsResponse = await dioClient
        .post('https://ipfs.infura.io:5001/api/v0/cat?arg=$ipfsHash',
            options: Options(
      responseDecoder: (responseBytes, options, responseBody) {
        print(responseBytes);
        image = responseBytes;
      },
    ));
    return UserModel(
        username: username, profileImage: image, userAddress: address);
  }

  Future<UserModel> getUserProfile(String address) async {
    var response = await dioClient.get(url + "/getUserProfile/$address");
    var ipfsHash = response.data["data"][0]["dpIpfsHash"];
    var image;
    var ipfsResponse = await dioClient
        .post('https://ipfs.infura.io:5001/api/v0/cat?arg=$ipfsHash',
            options: Options(
      responseDecoder: (responseBytes, options, responseBody) {
        print(responseBytes);
        image = responseBytes;
      },
    ));
    return UserModel.myProfile(response.data["data"][0], address, image);
  }

  Future<PostModel> getPost(int id, String userAddress) async {
    var response = await dioClient.get(url + "/getUserPost/$userAddress/$id");
    var ipfsHash = response.data["data"][0]["ipfsHash"];
    if (response.data["data"][0]["isImage"]) {
      var image;
      var ipfsResponse = await dioClient
          .post('https://ipfs.infura.io:5001/api/v0/cat?arg=$ipfsHash',
              options: Options(
        responseDecoder: (responseBytes, options, responseBody) {
          image = responseBytes;
        },
      ));

      return PostModel.imagePost(response.data["data"][0], image);
    } else {
      print(ipfsHash);
      var image;
      var ipfsResponse = await dioClient.post(
          'https://ipfs.infura.io:5001/api/v0/cat?arg=$ipfsHash',
          options: Options(
            responseType: ResponseType.bytes,
            responseDecoder: (responseBytes, options, responseBody) {
              print(responseBytes);
              image = responseBytes;
            },
          ));

      return PostModel.textPost(
          response.data["data"][0], utf8.decode(ipfsResponse.data));
    }
  }

  Future<int> getPostCount(String userAddress) async {
    var response = await dioClient.get(url + "/getPostCount/$userAddress");
    return response.data["data"][0]["postCount"];
  }

  Future<List<PostModel>> getUserPosts(String userAddress) async {
    int postCount = await getPostCount(userAddress);
    print(postCount);
    List<PostModel> posts = [];
    for (int i = 0; i < postCount; i++) {
      var post = await getPost(i, userAddress);
      posts.add(post);
    }
    return posts;
  }

  Future<bool> hasLiked(
      String userAddress, String followAddress, int postID) async {
    var response = await dioClient
        .get(url + "/hasLiked/$userAddress/$postID/$followAddress");
    return response.data["data"][0]["hasLiked"];
  }

  Future<void> like(String userAddress, String followAddress, int postID) async {
    Map<String, dynamic> requestMap = {
      "userAddress" : userAddress,
      "postID" : postID,
      "followAddress": followAddress
    }; 
    try {
      var response = await dioClient.post(url + "/likePost",
          data: requestMap,
          options: Options(headers: {
            "X-API-KEY": [apiKey]
          }, contentType: Headers.formUrlEncodedContentType));
      print(response.toString());
      return Right(response.data["data"][0]["txHash"]);
    } catch (e) {
      return Left(ErrorMessage(message: "Error!"));
    }
  }
}
