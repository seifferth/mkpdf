#!/bin/sed

# All expressions below use address spaces. Namely:
#     /\\begin{document}/,/\\end{document}/
# This means the rules are only applied inside the
# document body. Code blocks or special commands like
# \includepdf{filename.pdf} are not ignored, however.

# Abbreviations
# like e.g., i.e., z.B.
# - no mid space, line start
/\\begin{document}/,/\\end{document}/ s/\(^[a-z|A-Z]\.\)\([a-z|A-Z]\.\)/\1\\,\2/g
# - no mid space, mid line
/\\begin{document}/,/\\end{document}/ s/\([ \(][a-z|A-Z]\.\)\([a-z|A-Z]\.\)/\1\\,\2/g
# - mid-space, line start
/\\begin{document}/,/\\end{document}/ s/\(^[a-z|A-Z]\.\) \([a-z|A-Z]\.\)/\1\\,\2/g
# - mid-space, mid line
/\\begin{document}/,/\\end{document}/ s/\([ \(][a-z|A-Z]\.\) \([a-z|A-Z]\.\)/\1\\,\2/g
# nbsp after abbreviation (if space after abbreviation)
/\\begin{document}/,/\\end{document}/ s/\([a-z|A-Z]\.\\,[a-z|A-Z]\.\) /\1~/g

# Slim spaces around slash
# But only if the slash is already surrounded by spaces.
# Otherwise this could break paths or urls.
/\\begin{document}/,/\\end{document}/ s. / .\\,/\\,.g
