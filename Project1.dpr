program Project1;

{$APPTYPE CONSOLE}

uses
  Psapi,
  Windows,
  tlhelp32,
  SysUtils;

function GetTheParentProcessFileName(): String;
const
  BufferSize = 4096;
var
  HandleSnapShot  : THandle;
  EntryParentProc : TProcessEntry32;
  CurrentProcessId: DWORD;
  HandleParentProc: THandle;
  ParentProcessId : DWORD;
  ParentProcessFound  : Boolean;
  ParentProcPath      : String;

begin
  ParentProcessFound := False;
  HandleSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);   //enumerate the process
  if HandleSnapShot <> INVALID_HANDLE_VALUE then
  begin
    EntryParentProc.dwSize := SizeOf(EntryParentProc);
    if Process32First(HandleSnapShot, EntryParentProc) then    //find the first process
    begin
      CurrentProcessId := GetCurrentProcessId(); //get the id of the current process
      repeat
        if EntryParentProc.th32ProcessID = CurrentProcessId then
        begin
          ParentProcessId := EntryParentProc.th32ParentProcessID; //get the id of the parent process
          HandleParentProc := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, ParentProcessId);
          if HandleParentProc <> 0 then
          begin
              ParentProcessFound := True;
              SetLength(ParentProcPath, BufferSize);
              GetModuleFileNameEx(HandleParentProc, 0, PChar(ParentProcPath),BufferSize);
              ParentProcPath := PChar(ParentProcPath);
              CloseHandle(HandleParentProc);
          end;
          break;
        end;
      until not Process32Next(HandleSnapShot, EntryParentProc);
    end;
    CloseHandle(HandleSnapShot);
  end;

  if ParentProcessFound then
    Result := ParentProcPath
  else
    Result := '';
end;

begin

if (AnsiLowerCase(ExtractFileName(GetTheParentProcessFileName)) <> 'explorer.exe') and (AnsiLowerCase(ExtractFileName(GetTheParentProcessFileName)) <> 'cmd.exe') then
begin
exitprocess(0);
end;

Writeln('No Debugger Found!');
Writeln('Press <enter> to quit...');
Readln;
exitprocess(0);
end.
