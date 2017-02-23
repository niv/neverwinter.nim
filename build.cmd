
for %%v in (src\*.nim) do nim -p:"extlib/neverwinter.nim/src" -o:"bin\%%~nv.exe" -d:release c "%%v"
