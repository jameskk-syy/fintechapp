import 'package:xml/xml.dart';
class ProductsListResponse {
  final String statusCode;
  final List<LoanProduct> loans;

  ProductsListResponse({
    required this.statusCode,
    required this.loans,
  });

  factory ProductsListResponse.fromXml(XmlDocument document) {
    final responseNode = document.findAllElements('vmt:ProductsListResult').first;

    final statusCode = responseNode.findElements('c4:BankResponseCode').first.text;
    final formattedStatement = responseNode.findElements('c4:FormattedStatement').first.text;

    final loans = LoanProduct.parseFormattedStatement(formattedStatement);

    return ProductsListResponse(
      statusCode: statusCode,
      loans: loans,
    );
  }
}

class LoanProduct {
  final String productCode;
  final String productName;
  final int maxRepaymentPeriod;
  final int minApplicationAmount;
  final int maxApplicationAmount;
  final int minGuarantors;
  final int maxGuarantors;

  LoanProduct({
    required this.productCode,
    required this.productName,
    required this.maxRepaymentPeriod,
    required this.minApplicationAmount,
    required this.maxApplicationAmount,
    required this.minGuarantors,
    required this.maxGuarantors,
  });

  static List<LoanProduct> parseFormattedStatement(String input) {
    final cleaned = input.replaceAll('[', '').replaceAll(']', '');
    final lines = cleaned.split(',').map((line) => line.trim()).where((l) => l.isNotEmpty);

    return lines.map((line) {
      final parts = line.split('|').map((p) => p.trim()).toList();
      return LoanProduct(
        productCode: parts[0],
        productName: parts[1],
        maxRepaymentPeriod: int.parse(parts[2]),
        minApplicationAmount: int.parse(parts[3]),
        maxApplicationAmount: int.parse(parts[4]),
        minGuarantors: int.parse(parts[5]),
        maxGuarantors: int.parse(parts[6]),
      );
    }).toList();
  }
}
