module Fixme.Hash where

import Fixme.Base58

import Crypto.Hash
import Data.ByteArray qualified as BA
import Data.String
import Data.ByteString.Char8 qualified as BS8
import Data.ByteString.Lazy qualified as LBS
import Data.ByteString (ByteString)
import Data.Maybe
import Prettyprinter

type FixmeHashAlgorithm = Blake2b_256

newtype FixmeHash =
  FixmeHash ByteString
  deriving (Eq,Ord,Show)

class HasFixmeHash a where
  fixmeHash :: a -> FixmeHash

instance Pretty FixmeHash where
  pretty (FixmeHash h) = pretty (AsBase58 h)

instance IsString FixmeHash where
  fromString s = FixmeHash doDecode
    where
      doDecode =
        fromMaybe (error "invalid base58") $ fromBase58 (BS8.pack s)

instance HasFixmeHash ByteString where
  fixmeHash s = FixmeHash $! BA.convert digest
    where
      digest = hash s :: Digest FixmeHashAlgorithm

instance HasFixmeHash LBS.ByteString where
  fixmeHash s = FixmeHash $! BA.convert digest
    where
      digest = hashlazy s :: Digest FixmeHashAlgorithm

