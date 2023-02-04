enum StorageKeys {
  accessToken('accessToken'),
  instanceName('instanceName'),
  userId('userId');

  const StorageKeys(this.storageKey);
  final String storageKey;
}