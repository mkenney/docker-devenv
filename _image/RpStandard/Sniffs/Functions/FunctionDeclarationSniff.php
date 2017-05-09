<?php
/**
 * PEAR_Sniffs_Functions_FunctionDeclarationSniff.
 *
 * PHP version 5
 *
 * @category  PHP
 * @package   PHP_CodeSniffer
 * @author    Greg Sherwood <gsherwood@squiz.net>
 * @copyright 2006-2014 Squiz Pty Ltd (ABN 77 084 670 600)
 * @license   https://github.com/squizlabs/PHP_CodeSniffer/blob/master/licence.txt BSD Licence
 * @link      http://pear.php.net/package/PHP_CodeSniffer
 */
/**
 * PEAR_Sniffs_Functions_FunctionDeclarationSniff.
 *
 * Ensure single and multi-line function declarations are defined correctly.
 *
 * @category  PHP
 * @package   PHP_CodeSniffer
 * @author    Greg Sherwood <gsherwood@squiz.net>
 * @copyright 2006-2014 Squiz Pty Ltd (ABN 77 084 670 600)
 * @license   https://github.com/squizlabs/PHP_CodeSniffer/blob/master/licence.txt BSD Licence
 * @version   Release: @package_version@
 * @link      http://pear.php.net/package/PHP_CodeSniffer
 */
class RpStandard_Sniffs_Functions_FunctionDeclarationSniff implements PHP_CodeSniffer_Sniff {

    /**
     * Returns an array of tokens this test wants to listen for.
     *
     * @return array
     */
    public function register() {
        return array(
            T_FUNCTION,
            T_CLOSURE,
        );
    }

    /**
     * Processes this test, when one of its tokens is encountered.
     *
     * @param PHP_CodeSniffer_File $phpcsFile The file being scanned.
     * @param int                  $stackPtr  The position of the current token
     *                                        in the stack passed in $tokens.
     *
     * @return void
     */
    public function process(PHP_CodeSniffer_File $phpcsFile, $stackPtr) {
        $tokens = $phpcsFile->getTokens();
        if (isset($tokens[$stackPtr]['parenthesis_opener']) === false
            || isset($tokens[$stackPtr]['parenthesis_closer']) === false
            || $tokens[$stackPtr]['parenthesis_opener'] === null
            || $tokens[$stackPtr]['parenthesis_closer'] === null
        ) {
            return;
        }
        $openBracket  = $tokens[$stackPtr]['parenthesis_opener'];
        $closeBracket = $tokens[$stackPtr]['parenthesis_closer'];
        // Must be one space after the FUNCTION keyword.
        if ($tokens[($stackPtr + 1)]['content'] === $phpcsFile->eolChar) {
            $spaces = 'newline';
        } else if ($tokens[($stackPtr + 1)]['code'] === T_WHITESPACE) {
            $spaces = strlen($tokens[($stackPtr + 1)]['content']);
        } else {
            $spaces = 0;
        }
        if ($tokens[$stackPtr]['code'] === T_CLOSURE) {
            $expected = 0;
        } else {
            $expected = 1;
        }
        if ($spaces !== $expected) {
            $error = "Expected {$expected} space(s) after FUNCTION keyword; %s found";
            $data  = array($spaces);
            $fix   = $phpcsFile->addFixableError($error, $stackPtr, 'SpaceAfterFunction', $data);
            if ($fix === true) {
                if ($spaces === 0) {
                    $phpcsFile->fixer->addContent($stackPtr, ' ');
                } else {
                    $phpcsFile->fixer->replaceToken(($stackPtr + 1), ' ');
                }
            }
        }
        // Must be one space before the opening parenthesis. For closures, this is
        // enforced by the first check because there is no content between the keywords
        // and the opening parenthesis.
        if ($tokens[$stackPtr]['code'] === T_FUNCTION) {
            if ($tokens[($openBracket - 1)]['content'] === $phpcsFile->eolChar) {
                $spaces = 'newline';
            } else if ($tokens[($openBracket - 1)]['code'] === T_WHITESPACE) {
                $spaces = strlen($tokens[($openBracket - 1)]['content']);
            } else {
                $spaces = 0;
            }
            if ($spaces !== 0) {
                $error = 'Expected 0 spaces before opening parenthesis; %s found';
                $data  = array($spaces);
                $fix   = $phpcsFile->addFixableError($error, $openBracket, 'SpaceBeforeOpenParen', $data);
                if ($fix === true) {
                    $phpcsFile->fixer->replaceToken(($openBracket - 1), '');
                }
            }
        }
        // Must be one space before and after USE keyword for closures.
        if ($tokens[$stackPtr]['code'] === T_CLOSURE) {
            $use = $phpcsFile->findNext(T_USE, ($closeBracket + 1), $tokens[$stackPtr]['scope_opener']);
            if ($use !== false) {
                if ($tokens[($use + 1)]['code'] !== T_WHITESPACE) {
                    $length = 0;
                } else if ($tokens[($use + 1)]['content'] === "\t") {
                    $length = '\t';
                } else {
                    $length = strlen($tokens[($use + 1)]['content']);
                }
                if ($length !== 0) {
                    $error = 'Expected 0 spaces after USE keyword; found %s';
                    $data  = array($length);
                    $fix   = $phpcsFile->addFixableError($error, $use, 'SpaceAfterUse', $data);
                    if ($fix === true) {
                        if ($length === 0) {
                            $phpcsFile->fixer->addContent($use, ' ');
                        } else {
                            $phpcsFile->fixer->replaceToken(($use + 1), ' ');
                        }
                    }
                }
                if ($tokens[($use - 1)]['code'] !== T_WHITESPACE) {
                    $length = 0;
                } else if ($tokens[($use - 1)]['content'] === "\t") {
                    $length = '\t';
                } else {
                    $length = strlen($tokens[($use - 1)]['content']);
                }
                if ($length !== 1) {
                    $error = 'Expected 1 space before USE keyword; found %s';
                    $data  = array($length);
                    $fix   = $phpcsFile->addFixableError($error, $use, 'SpaceBeforeUse', $data);
                    if ($fix === true) {
                        if ($length === 0) {
                            $phpcsFile->fixer->addContentBefore($use, ' ');
                        } else {
                            $phpcsFile->fixer->replaceToken(($use - 1), ' ');
                        }
                    }
                }
            }
        }
    }
}
