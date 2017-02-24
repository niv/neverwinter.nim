
for %%v in (src\*.nim) do nim -o:"bin\%%~nv.exe" -d:release c "%%v"
