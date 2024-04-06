abstract class BaseRepository<T> {
  Future<int?> create(T item);
  Future<T> view(dynamic id);
  Future<dynamic> update(T item);
  Future<void> delete(dynamic id);
  Future<List<T>> viewAll();
}
