from random import randrange
wordlist = [word.rstrip() for word in open("data/sowpods")]

def get_word(wordlist=wordlist):
    return wordlist[randrange(0, len(wordlist))]

