import 'package:xml/xml.dart';
class CheckLimitResponse {
  final String statusCode;
  final String message;
  final String loanBalance;
  final String limit;


  factory CheckLimitResponse.fromXml(XmlDocument document) {
    final responseNode = document.findAllElements('vmt:GetLoanCreditLimitResult').first;

    final statusCode = responseNode.findElements('c4:BankResponseCode').first.text;
    final message = responseNode.findElements('c4:AdditionalInformation').first.text;
    final loanBalance = responseNode.findElements('c4:ExistingLoanBalance').first.text;
    final limit = responseNode.findElements('c4:MaxQualifyAmount').first.text;
    return CheckLimitResponse(
      statusCode: statusCode,
      message: message,
      loanBalance: loanBalance,
      limit: limit
    );
  }

  CheckLimitResponse({required this.statusCode, required this.message, required this.loanBalance, required this.limit});

  


}

