hint("Processing", false)

switch("path", ".")
switch("path", "private")

if NimVersion == "0.19.0":
  switch("nilseqs", "on")
