require 'rubygems'
require 'aes'

key = "4878B22E76379B55C962B18DDBC188D82299F8F52E3E698D0FAF29A40ED64B21"
iv   = "WA7hap7AGUkevuth"
msg  = "01c10b77de3795c18c3f38307cb3d7ea5b72ca94b099007d27555dd4076010832215d37e52aca503848cb41eb47c6ffb"

puts AES.decrypt(msg, key, {:iv => iv})



#key  = "4878B22E76379B55C962B18DDBC188D82299F8F52E3E698D0FAF29A40ED64B21".to_a.pack("H*")
#msg  = "01c10b77de3795c18c3f38307cb3d7ea5b72ca94b099007d27555dd4076010832215d37e52aca503848cb41eb47c6ffb".to_a.pack('H*')
#iv   = "WA7hap7AGUkevuth" #AES.iv(:base_64)
#enc1 = AES.encrypt(msg, key, {:iv => iv})
#enc2 = AES.encrypt(msg, key, {:iv => iv,:cipher => "AES-256-ECB"})


#key_string = "4878B22E76379B55C962B18DDBC188D82299F8F52E3E698D0FAF29A40ED64B21".to_a.pack('H*')
#key_length = key_string.length * 8
#iv_string  = "WA7hap7AGUkevuth"
#mode = "ECB"

#Aes.check_key(key_string, key_length)
#Aes.check_iv(iv_string)
#Aes.check_kl(key_length)
#Aes.check_mode(mode)
#Aes.init(key_length, mode, key_string, iv_string)

#puts Aes.encrypt_buffer(key_length, mode, key_string, iv_string, msg)

#puts enc2


#print Crypt.decrypt('01c10b77de3795c18c3f38307cb3d7ea5b72ca94b099007d27555dd4076010832215d37e52aca503848cb41eb47c6ffb','4878B22E76379B55C962B18DDBC188D82299F8F52E3E698D0FAF29A40ED64B21','WA7hap7AGUkevuth',"AES-128-ECB.")







