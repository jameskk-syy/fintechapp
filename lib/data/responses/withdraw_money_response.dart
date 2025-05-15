import 'package:xml/xml.dart';
class WithdrawMoneyResponse {
  final String statusCode;
  final String message;


  factory WithdrawMoneyResponse.fromXml(XmlDocument document) {
    final responseNode = document.findAllElements('vmt:VMTInitiatedSavingsWithdrawalResult').first;

    final statusCode = responseNode.findElements('c4:BankResponseCode').first.text;
    final message = responseNode.findElements('c4:AdditionalInformation').first.text;

    return WithdrawMoneyResponse(
      statusCode: statusCode,
      message : message,
    );
  }

  WithdrawMoneyResponse({required this.statusCode, required this.message});



}

