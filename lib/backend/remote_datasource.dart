import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:decentragram/core/errors.dart';
import 'package:decentragram/database/firestore_repository.dart';
import 'package:decentragram/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart'; 

class RemoteDataSource {
  var dioClient = Dio();
  String url =
      'https://mainnet-api.maticvigil.com/v1.0/contract/0xf0c7f1f08e32a8e5a23e7744bca93a066a5e25bb';
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
      // print(response.statusMessage);

      return Right(response.data["data"][0]["txHash"]);
    } catch (e) {
      print(e.response);
      return Left(ErrorMessage(message: "Error!"));
    }
  }
}
