// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

class PaginationFilter {
  PaginationFilter({
    this.page,
    this.limit,
  });
  int? page;
  int? limit;

  @override
  String toString() => 'PaginationFilter(page: $page, limit: $limit)';
}
