#include "utf-util.h"

#include <string>

using namespace std;

// http://shakddoo.github.io/ndk-unicode-utf8/

string UnicodeToUtf8(const wstring& source_str)
{
    string value;
    int dest_len            = 0;
    int source_len          = source_str.length();
    const wchar_t* source   = source_str.c_str();
    char* dest              = new char[source_len*3 + 1];

    for(int i = 0 ; i < source_len ; i++)
    {
        if(source[i]<= 0x7F)
        {
            dest[dest_len] = source[i];
            dest_len++;
        }
        else if(source[i] >= 0x80 && source[i] <=0x7FF)
        {
            wchar_t tmp = source[i];
            char first = 0, second = 0, third = 0;
            for(int j = 0; j < 3 ; j++)
            {
                wchar_t tmp_quota = tmp%16;
                switch(j)
                {
                    case 0: third    = tmp_quota; break;
                    case 1: second   = tmp_quota; break;
                    case 2: first    = tmp_quota; break;
                }
                tmp /= 16;
            }

            dest[dest_len] = 0xC0 + (first<<2) + (second>>2);
            dest[dest_len+1] = 0x80 + (((second%8)%4) << 4) + third;
            dest_len +=2;
        }
        else if(source[i] >= 0x800 && source[i] <=0xFFFF)
        {
            wchar_t tmp = source[i];
            char first = 0, second = 0, third = 0, fourth = 0;
            for(int j = 0; j < 4 ; j++)
            {
                wchar_t tmp_quota = tmp%16;
                switch(j)
                {
                    case 0: fourth   = tmp_quota; break;
                    case 1: third    = tmp_quota; break;
                    case 2: second   = tmp_quota; break;
                    case 3: first    = tmp_quota; break;
                }
                tmp /= 16;
            }

            dest[dest_len] = 0xE0 + first;
            dest[dest_len+1] = (((0x80 + second) << 2) + third) >> 2;
            dest[dest_len+2] = 0x80 + (((third%8)%4) << 4) + fourth;
            dest_len +=3;
        }
        else
            return value;
    }
    dest[dest_len++] = '\0';

    value.assign(dest, dest_len);
    delete[] dest;
    return value;
}

char *utf_util_utf16_to_utf8(uint16_t *str) {
  std::wstring ws(reinterpret_cast<wchar_t*>(str)); // FIXME(syoyo): Is this typecast case?

  std::string ret = UnicodeToUtf8(ws);

  char *s = static_cast<char *>(malloc(ret.length() + 1));
  memcpy(s, ret.c_str(), ret.length());
  s[ret.length()] = '\0';

  return s;
}
