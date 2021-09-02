#!/bin/python
import re
import sys

TIMESTAMP_REGEX = re.compile(r'(?P<time>([0-9]{4}-[0-9]{2}-[0-9]{2}[T ]?'
            '[0-9][0-9]*:[0-9]{2}:[0-9]{2}(\.[0-9]{1,6})?)'
            '(([-+][0-9]{2}:[0-9]{2})|Z)?)')


def makeEscapedString(message):
    escapedMessage=""
    escapeList = ['{', '}', '_', '*']
    for c in message:
        if c in escapeList:
            escapedMessage += '\\'
        escapedMessage += c
    return escapedMessage

def formattedTime(matchobj):
    return "*"+matchobj.group(0)+"*"

def formatTime(message):
    return TIMESTAMP_REGEX.sub(formattedTime, message)

def formatLogLevel(message):
    if re.search(r" NOTICE ", message):
        return re.sub(r" NOTICE ", " {color:green} NOTICE {color} ", message)
    if re.search(r" INFO ", message):
        return re.sub(r" INFO ", " {color:green} INFO {color} ", message)
    if re.search(r" WARNING ", message):
        return re.sub(r" WARNING ", " {color:orange} WARNING {color}", message)
    if re.search(r" CRITICAL ", message):
        return re.sub(r" CRITICAL ", " {color:red} CRITICAL {color}", message)
    if re.search(r" ERROR ", message):
        return re.sub(r" ERROR ", " {color:red} ERROR {color}", message)
    return message

def main():
    output = "{panel:borderStyle=dashed|borderColor=#ccc|bgColor=#eff1f4}\n"
    for line in sys.stdin:
        line = line.rstrip('\n')
        prettyLine = makeEscapedString(line)
        prettyLine = formatTime(prettyLine)
        prettyLine = formatLogLevel(prettyLine)

        # Add monospacing and newline
        prettyLine = "{{" + prettyLine + "}}\n"
        output += prettyLine
    output += "\n{panel}"
    print output

if __name__ == '__main__':
    main()