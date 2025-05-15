import 'package:xml/xml.dart';
class ApplyLoanResponse {
  final String statusCode;
  final String message;


  factory ApplyLoanResponse.fromXml(XmlDocument document) {
    final responseNode = document.findAllElements('vmt:LoanRequestResult').first;

    final statusCode = responseNode.findElements('c4:BankResponseCode').first.text;
    final message = responseNode.findElements('c4:AdditionalInformation').first.text;

    return ApplyLoanResponse(
      statusCode: statusCode,
      message:message
    );
  }

  ApplyLoanResponse({required this.statusCode, required this.message});

}

