#!/usr/bin/python3
import re, sys, os

def lex_file (filename):
    KEYWORDS = """and array asm begin break case
    const constructor continue destructor div do downto else end
    false file for function goto if implementation in inline
    interface label mod nil not object of on operator or packed
    procedure program record repeat set shl shr string then to
    true type unit until uses var while with xor
    
    as attribute class cardinal constref dispose except exit exports finalization
    finally inherited initialization is library new on out property
    raise self threadvar try""".split()

    PATTERNS = (
        ("string", r"\'[^\']*\'"),
        ("comment", r"\{[^\$][^}]+\}"),
        ("directive", r"\{\$[^}]+\}"),
        ("blank", r"[\s\n]+"),
        ("name", r"[\w\d][\w\d_]*"),
        ("spec_char", r"(:=|\(|\)|\.|\;|\-|\+|\/|\*|\=|\]|\[|,|:|\^|\$)"),
        ("integer", r"\d+(?![\.\w])"),
        ("real", r"\d+\.\d+")
    )

    if not os.path.exists(filename):
        raise FileNotFoundError("No "+filename)
    with open(filename, "r") as file_in:
        text = file_in.read()
    
    result = []
    rel_pos = 0

    while (text!=""):
        found = False
        for keyword in KEYWORDS:
            mtch = re.match("^"+keyword, text, re.IGNORECASE)
            if mtch:
                result.append({
                    "body":mtch.group(0),
                    "type":"keyword",
                    "start":rel_pos
                })
                text = text[len(mtch.group(0)):]
                rel_pos += len(mtch.group(0))
                found = True
                break
        if found:
            continue
        for pattern in PATTERNS:
            mtch = re.match("^"+pattern[1], text)
            if mtch:
                if not pattern[0] in ("blank", "comment"):
                    result.append({
                        "body":mtch.group(0),
                        "type":pattern[0],
                        "start":rel_pos
                    })
                text = text[len(mtch.group(0)):]
                rel_pos += len(mtch.group(0))
                found = True
                break
        if not found:
            raise SyntaxError("Unknown pattern at "+str(rel_pos))

    with open(filename+".python.txt", "w") as file_out:
        for r in result:
            file_out.write(r["body"]+" - "+r["type"]+" at "+str(r["start"])+"\n")
    return 1

if __name__ == "__main__":
    if len(sys.argv)>1:
        lex_file(sys.argv[1])
