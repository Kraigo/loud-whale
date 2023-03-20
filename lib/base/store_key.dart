enum StorageKeys {
  accessToken('accessToken'),
  instanceName('instanceName'),
  userId('userId'),

  statusesMaxCharacter('statuses_max_characters'),
  statusesMaxAttachments('statuses_max_attachments'),
  pollMaxOptions('poll_max_options'),
  pollMaxCharacters('poll_max_characters_per_option'),
  accessabilityDarkMode('accessabilityDarkMode');

  const StorageKeys(this.storageKey);
  final String storageKey;
}
