for %%v in (src\*.nim) do nim -o:"bin\%%~nv.exe" c "%%v"
