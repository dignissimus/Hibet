{-# LANGUAGE QuasiQuotes     #-}
{-# LANGUAGE TemplateHaskell #-}

module Cli
       ( trans
       ) where

import Control.Applicative (many, optional, (<|>))
import Data.Foldable (find)
import Data.List (sortBy)
import Data.Text (Text)
import Data.Version (showVersion)
import Development.GitRev (gitCommitDate, gitDirty, gitHash)
import NeatInterpolation (text)
import Options.Applicative (Parser, ParserInfo, auto, command, execParser, fullDesc, help, helper,
                            info, infoHeader, infoOption, long, metavar, option, progDesc, short,
                            subparser)
import Options.Applicative.Help.Chunk (stringChunk)

import Labels (LabelFull (..), labels)
import Paths_Hibet (version)
import Pretty
import Tibet (start)

import qualified Data.Text as T


----------------------------------------------------------------------------
-- Command data types
----------------------------------------------------------------------------

-- | Represent all available commands
data Command
    -- | @shell@ command launch translating shell
    = Shell Select
    | Om
    | ShowOption Opt

-- | Commands parsed with @show@ command
data Opt = Names | Meta (Maybe Int)

type Select = [Int]

---------------------------------------------------------------------------
-- CLI
---------------------------------------------------------------------------

trans :: IO ()
trans = execParser prsr >>= runCommand

-- | Run 'tibet' with cli command
runCommand :: Command -> IO ()
runCommand = \case
    Shell select -> start select
    Om -> putColorDoc magenta om
    ShowOption opt -> runShow opt

runShow :: Opt -> IO ()
runShow = \case
    Names -> do
        titles <- sortLabels <$> labels
        mapM_ (\LabelFull{..} -> putColorDoc green $ number lfId <> lfLabel) titles
    Meta Nothing -> do
        titles <- labels
        mapM_ (\LabelFull{..} -> do
            putColorDoc green $ number lfId <> lfLabel
            putColorDoc blue lfMeta
            ) titles
    Meta (Just n) -> find (\LabelFull{..} -> n == lfId) <$> labels >>= \case
        Nothing -> putColorDoc red "No such number of dictionary!"
        Just LabelFull{..} -> do
            putColorDoc green $ number lfId <> lfLabel
            putColorDoc blue lfMeta
  where
    number :: Int -> Text
    number n = T.pack $ show n <> ". "
    sortLabels :: [LabelFull] -> [LabelFull]
    sortLabels = sortBy (\(LabelFull _ a _ _) (LabelFull _ b _ _) -> compare a b)

----------------------------------------------------------------------------
-- Parsers
----------------------------------------------------------------------------

-- | Main parser of the app.
prsr :: ParserInfo Command
prsr = modifyHeader
    $ info (helper <*> versionP <*> (shellP <|> commands)) fullDesc

versionP :: Parser (a -> a)
versionP = infoOption tibetVersion
    $ long "version"
   <> short 'v'
   <> help "Show Hibet's version"

tibetVersion :: String
tibetVersion = T.unpack $ T.intercalate "\n" $ [sVersion, sHash, sDate] ++ [sDirty | $(gitDirty)]
  where
    sVersion = textToColorText green $ "Hibet " <> "v" <> T.pack (showVersion version)
    sHash = " ➤ " <> (textToColorText blue "Git revision: " <> $(gitHash))
    sDate = " ➤ " <> (textToColorText blue "Commit date:  " <> $(gitCommitDate))
    sDirty = textToColorText red "There are non-committed files."

-- All possible commands.
commands :: Parser Command
commands = subparser
    $ command "shell" (info (helper <*> shellP) $ progDesc "Start the translate shell")
   <> command "om" (info (helper <*> pure Om) $ progDesc "Print Om to a terminal")
   <> command "show" (info (helper <*> showP) $ progDesc "Show titles or descriptions of dictionaries")

shellP :: Parser Command
shellP = Shell <$> idListP

idListP :: Parser [Int]
idListP = many $ option auto
    $ long "select"
   <> short 's'
   <> help "Select id of dictionary"
   <> metavar "DICT_ID"

showP :: Parser Command
showP = ShowOption <$> subparser
    ( command "names" (info (helper <*> pure Names) $ progDesc "Show dictionary titles")
   <> command "meta" (info (helper <*> dictNumber) $ progDesc "Show dictionary descriptions")
    )

dictNumber :: Parser Opt
dictNumber = Meta <$> optional
    (option auto
        (  long "dictionary"
        <> short 'd'
        <> metavar "DICTIONARY_NUMBER"
        <> help "Show specific dictionary description"
        ))

----------------------------------------------------------------------------
-- Beauty util
----------------------------------------------------------------------------

-- to put custom header which doesn't cut all spaces
modifyHeader :: ParserInfo a -> ParserInfo a
modifyHeader p = p {infoHeader = stringChunk $ T.unpack artHeader}

artHeader :: Text
artHeader = textToColorText yellow "Hibet is command line translator from Tibet to English language."

endLine :: Text
endLine = "\n"

om :: Text
om = [text|
$endLine
                             /hd+
                           /Nd::ohs.
                          /MM- .NMm+
                          :MMdosMMN.        '.-.
                  'oNNmdyo:/dMMMms/ohmNNNNNmy:'
                 'hMMMMMNmNN+.' .dmhyyso+/.
                 '.' '...:+ohy:.+.
                              .-     '.
              :yddddo '/mmNNmmdddmNNNm-  .mhhd-
             -mMMMMN. yMMMMMMMMMMMMMm+  +NMMMMo
             dMMMMM/  .+smMMMMMMMMd:.  :NMMMMMs
             'mMMMh    .hMMMs:hMMMM/    .mMMMMo
              +MMM/   -NNh/'   :mMMN:    .mMMMo
              'NMm    ms''-.'   'oNMN-    :MMM+
               mMy   -o+dNMMMNh:  .hMN-    hMM/
               yMy   .shydMMMMMM+   /Nm.   :MM:
               :Mh    '   :NMMMMm    -mm-  'mM'
                dN.        yMMMMo      sN-  sm
                'ym.      :NMMMo'       /d: /d
                  -yo:'.:yMMdo.          'yo.s
                     .--:--'               +y+
                                            :+
            |]
