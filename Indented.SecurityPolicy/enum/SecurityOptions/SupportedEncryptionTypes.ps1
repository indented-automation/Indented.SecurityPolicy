[Flags()]
enum SupportedEncryptionTypes {
    DES_CBC_CRC      = 1
    DES_CBC_MD5      = 2
    RC4_HMAC_MD5     = 4
    AES128_HMAC_SHA1 = 8
    AES256_HMAC_SHA1 = 16
    Future           = 2147483616
}