Export a keychain
-----------------

1. umask 0077
1. security dump-keychain -d my.keychain > raw_passwords.txt
1. ./extract_keychain.rb raw_passwords.txt > passwords.txt
1. openssl des3 -in passwords.txt -out passwords.des3 -pass stdin
1. srm -s raw_passwords.txt passwords.txt
1. umask 0022

Later, to decrypt:

1. umask 0077
1. openssl des3 -d < passwords.des3 > decrypted_passwords
1. # enjoy
1. srm -s decrypted_passwords
1. umask 0022

References
-----------

1. http://stackoverflow.com/questions/717095/is-there-a-quick-and-easy-way-to-dump-the-contents-of-a-macos-x-keychain
1. http://selfsuperinit.com/2014/01/20/exporting-icloud-keychain-passwords-as-a-plain-text-file/
