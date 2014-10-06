
local({
    r = getOption("repos")
    r["CRAN"] = "http://cran.r-project.org/"
    options(repos = r)
})
options(browserNLdisabled = TRUE)
options("digits.secs"=3)
options(prompt="ℝ> ")
options(stringsAsFactors=TRUE)
options(showWarnCalls=TRUE)
options(showErrorCalls=TRUE)
options(error=NULL)
options(warn=0)
options(max.print=500)
options(warnPartialMatchDollar = TRUE)
Sys.setenv(LANG = "en_US.UTF-8")
Sys.setlocale("LC_COLLATE", "en_US.UTF-8")
Sys.setlocale("LC_MESSAGES", "en_US.UTF-8")
library(assertthat)
library(testthat)
library(stringr)
library(sqldf)
library(MASS)
library(jsonlite)
library(data.table)
library(xlsx)
library(XML)
library(magrittr)
library(devtools)
library(reshape2)
library(tidyr)
library(lubridate)
library(plyr)
library(dplyr)
library(testit)
library(knitr)
library(fortunes)
.First <- function() {
    gcr <- new.env()
    gcr$attach.unsafe <- attach
    gcr$attach <- function(...) {
        warning("NEVER USE ATTACH! Use `unsafe.attach` if you must.")
        attach.unsafe(...)
    }
    gcr$require <- function(...) {
        warning("Are you sure you wanted `require` instead of `library`?")
        base::require(...)
    }
    gcr$lsnofun <- function(name = parent.frame()) {
        obj <- ls(name = name)
        obj[!sapply(obj, function(x) is.function(get(x)))]
    }
    gcr$recoveronerror <- function() {
        options(error=recover)
    }
    
    gcr$recoveronerroroff <- function() {
        options(error=NULL)
    }
    gcr$erroronwarn <- function() {
        options(warn=2)
    }
    
    gcr$erroronwarnoff <- function() {
        options(warn=0)
    }
    options(sqldf.driver = "SQLite")
    gcr$printdf <- function(df) {
        if (nrow(df) > 10) {
            print(head(df, 5))
            cat("---\n")
            print(tail(df, 5))
        } else {
            print(df)
        }
    }
    gcr$printlen <- function(len=500) {
        options("max.print" = len)
    }
    gcr$hundred <- function(df, idx=0) {
        df[idx:(idx+100),]
    }
    base::attach(gcr, name="gcr", warn.conflicts = FALSE)
}
fortune()
