# Challenge from https://twitter.com/_stevo/status/1159532213349675008?s=20
from string import ascii_lowercase as lc
from string import ascii_uppercase as uc
from base64 import b64decode

cipher:str = """Vemxpmr'w Gleppirki HG27 
Xli jsyvxl gsqtixmxmsr fikmrw. 
Gsrwmhiv gevijyppc xs wspzi iegl tvsfpiq amxl almgl csy evi jegih. 
Jmrh mppyqmrexmsr! 
Xli irgshih xibx fipsa ampp pieh xs xli ribx tivtpibmxc."""

def rot(n):
    """ Generic alphabet rotation function.
    """
    trans_table = str.maketrans(
        lc + uc,
        lc[n:] + lc[:n] + uc[n:] + uc[:n]
    )

    return lambda s: s.translate(trans_table)


if __name__ == "__main__":
    # Hints: HG27 -> DC27, also 2 occurrences of 'Xli'
    # which likely translates to 'The'.
    # Shifting by 4 characters:
    unrot_4 = rot(-4)
    print(unrot_4(cipher))
    # Base64 string at the end starting with aHR which very likely is
    # the beginning of 'http:...'
    print(b64decode("aHR0cDovL2RjMjcubWluZXJ2YWxsdXguY29tL2NoYWxsZW5nZS8=").decode())
