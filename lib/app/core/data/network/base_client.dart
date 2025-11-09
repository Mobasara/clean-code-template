abstract class BaseClient {
  Future<dynamic> getApi({url, data, required context});
  Future<dynamic> postApi({url, data, required context});
  Future<dynamic> updateApi({url, data, required context});
  Future<dynamic> deleteApi({url, required context});
}
