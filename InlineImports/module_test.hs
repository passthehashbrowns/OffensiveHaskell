{-# LANGUAGE TemplateHaskell #-}

module Module_test where
import Language.Haskell.TH
import Language.Haskell.TH.Syntax
import Foreign (Ptr)
--import System.Win32.Types (nullPtr, DWORD, LPCSTR, WORD, LPBYTE, HANDLE, BOOL, DWORD64, getLastError, Addr)
import Data.Word (Word8, Word32)

callOpenProcess :: ExpQ
callOpenProcess = do
	n <- newName "openProcess"
	d <- forImpD CCall unsafe "windows.h OpenProcess" n [t|Word32 -> Bool -> Int -> Ptr ()|]
	addTopDecls [d]
	[|$(varE n)|]
	
callVirtualAllocEx :: ExpQ
callVirtualAllocEx = do
	n <- newName "virtualAllocEx"
	d <- forImpD CCall unsafe "windows.h VirtualAllocEx" n [t|Ptr () -> Ptr () -> Word32 -> Word32 -> Word32 -> Ptr ()|]
	addTopDecls [d]
	[|$(varE n)|]
	
callWriteProcessMemory :: ExpQ
callWriteProcessMemory = do
	n <- newName "writeProcessMemory"
	d <- forImpD CCall unsafe "windows.h WriteProcessMemory" n [t|Ptr () -> Ptr () -> Ptr Word8 -> Word32 -> Ptr Word32 -> Bool|]
	addTopDecls [d]
	[|$(varE n)|]

callCreateRemoteThread :: ExpQ
callCreateRemoteThread = do
	n <- newName "createRemoteThread"
	d <- forImpD CCall unsafe "windows.h CreateRemoteThread" n [t|Ptr () -> Ptr Word8 -> Word32 -> Ptr () -> Ptr Word8 -> Word32 -> Ptr Word8 -> Ptr ()|]
	addTopDecls [d]
	[|$(varE n)|]

--PAGE_EXECUTE_READWRITE 0x40
--MEM_COMMIT 0x00001000