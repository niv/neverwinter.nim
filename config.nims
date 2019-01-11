hint("Processing", false)

switch("path", ".")
switch("path", "private")

if NimVersion == "0.19.0" or
   NimVersion == "0.19.2":
  switch("nilseqs", "on")
