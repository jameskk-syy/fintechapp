import 'package:xml/xml.dart';
class LoanAccountListResponse {
  final String statusCode;
  final List<LoanAccounts> loanAccounts;

  LoanAccountListResponse({
    required this.statusCode,
    required this.loanAccounts,
  });

  factory LoanAccountListResponse.fromXml(XmlDocument document) {
    final responseNode = document.findAllElements('vmt:LoanAccountsResult').first;

    final statusCode = responseNode.findElements('c4:BankResponseCode').first.text;
    final formattedStatement = responseNode.findElements('c4:FormattedStatement').first.text;

    final loanAccounts = LoanAccounts.parseFormattedStatement(formattedStatement);

    return LoanAccountListResponse(
      statusCode: statusCode,
      loanAccounts: loanAccounts,
    );
  }
}

class LoanAccounts {
  final String id;
  final String accountName;
  final String disbursedDate;
  final String openingDate;
  final String accountNumber;
  final double accountBalance;
  

  LoanAccounts({
    required this.id,
    required this.accountName,
    required this.disbursedDate,
    required this.openingDate,
    required this.accountBalance,
    required this.accountNumber,
  });

  static List<LoanAccounts> parseFormattedStatement(String input) {
    final cleaned = input.replaceAll('[', '').replaceAll(']', '');
    final lines = cleaned.split(',').map((line) => line.trim()).where((l) => l.isNotEmpty);

    return lines.map((line) {
      final parts = line.split('|').map((p) => p.trim()).toList();
      return LoanAccounts(
        id: parts[0],
        accountNumber:parts[1],
        accountName: parts[2],
        accountBalance: double.parse(parts[3]),
        disbursedDate: parts[4],
        openingDate: parts[5],
      );
    }).toList();
  }
}
