import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:decentragram/core/errors.dart';
import 'package:decentragram/database/firestore_repository.dart';
import 'package:decentragram/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class RemoteDataSource {
  var dioClient = Dio();
  static const String maticURL =
      'https://mainnet-api.maticvigil.com/v1.0/contract/';
  static const  String contractAddress = "0x8f487b643bdbc147b54f3af024c08d4ab5b95b1a";
  String url = maticURL + contractAddress;
  String ipfs = 'https://ipfs.infura.io:5001/api/v0/add?pin=false';
  String apiKey = 'd4fdc5d6-ce7b-4624-ba95-7ba359ca3bdd';
  FirestoreRepository repo = FirestoreRepository();

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
}
