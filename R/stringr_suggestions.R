

paste00 <- function(...) paste0(..., collapse = "")

stri_sub_no_stringi <- function(str, from, to) {
  out <- str
  nchar_out <- nchar(out) + 1L
  if (length(from) != 1L || length(to) != 1L) {
    stop("Internal error: stringi::stri_sub replacement can only handle ",
         "length-one froms and tos. \n\t",
         "length(from) = ", length(from), "\n\t",
         "length(to) = ", length(to), "\n",
         "If you are a user, please file an issue. ",
         "As a workaround, install.packages('stringr') and try again.")
  }
  FROM <- rep_len(from, length(out))
  TO <- rep_len(to, length(out))
  if (from < 0L) {
    FROM <- nchar_out + from
  } else {
    FROM <- rep_len(from, length(out))
  }
  if (to < 0L) {
    TO <- nchar_out + to
  } else {
    TO <- rep_len(to, length(out))
  }
  substr(out, FROM, TO)
}

stri_sub <- function(str, from = 1L, to = -1L, .len) {
  if (requireNamespace("stringi", quietly = TRUE)) {
    if (missing(.len)) {
      stringi::stri_sub(str = str, from = from, to = to)
    } else {
      stringi::stri_sub(str = str, from = from, to = to, length = .len)
    }
  } else {
    stri_sub_no_stringi(str = str, from = from, to = to)
  }
}

# These are taken from stringr source code.
stringr__str_sub <- function (string, start = 1L, end = -1L) {
  if (is.matrix(start)) {
    stri_sub(string, from = start)
  }
  else {
    stri_sub(string, from = start, to = end)
  }
}

stringr__str_sub_assign <- function (string, start = 1L, end = -1L, omit_na = FALSE, value) {
  # if (requireNamespace("stringr", quietly = TRUE)) {
  #   stringr::str_sub(string, start, end) <- value
  #   return(string)
  # }

  out <- string
  from <- start
  to <- end
  nchar_out <- nchar(out) + 1L
  if (length(from) != 1L || length(to) != 1L) {
    stop("Internal error: stringi::stri_sub replacement can only handle ",
         "length-one froms and tos. \n\t",
         "length(from) = ", length(from), "\n\t",
         "length(to) = ", length(to), "\n",
         "If you are a user, please file an issue. ",
         "As a workaround, install.packages('stringr') and try again.")
  }
  FROM <- rep_len(from, length(out))
  TO <- rep_len(to, length(out))
  if (from < 0L) {
    FROM <- nchar_out + from
  } else {
    FROM <- rep_len(from, length(out))
  }
  if (to < 0L) {
    TO <- nchar_out + to
  } else {
    TO <- rep_len(to, length(out))
  }

  # stringr::str_sub<- differs from substr()<-
  # when the nchar(replacement) of the substr

  # y <- "abc"
  # z <- "xyz"
  # stringr::str_sub(y, 2, 2) <- z
  # y
  # => "axyzc"

  out_split <- strsplit(out, split = "")[[1L]]
  out <- paste00(c(if (FROM > 1) paste00(out_split[seq_len(FROM - 1L)]),
                   value,
                   if (length(out_split) - TO >= 1) {
                     paste00(out_split[seq.int(TO + 1L, length(out_split))])
                   }))




  out
}


#' @param ss A set of strings (i.e. a vector of words)
#' @param width,indent,exdent as in str_wrap
#' @return A vector of wrapped strings
#' @noRd
.wrapper <- function(ss, width) {
  # + 1 for spaces
  sswidths <- cumsum(nchar(ss) + 1L)
  if (length(sswidths) <= 1L ||
      sswidths[length(sswidths)] < width) {
    return(ss)
  }
  for (i in seq_along(ss)) {

    if (sswidths[i] > width) {
      return(paste(paste0(ss[seq_len(i)],
                          collapse = " "),
                   paste0(.wrapper(ss[-seq_len(i)], width),
                          collapse = " "),
                   sep = "\n"))
    }
  }
}


stringr__str_wrap <- function(string, width = 80, indent = 0, exdent = 0) {
  if (use_stringr()) {
    stringr::str_wrap(string, width, indent, exdent)
  } else {
    unlist(
      lapply(
        string,
        function(s) {
          ss <- strsplit(s, split = " ", fixed = TRUE)[[1L]]
          out <- .wrapper(ss, width = width)
          c(formatC(trimws(out[1]), width = width),
            if (length(out) > 1) {
              out[-1]
            })
        }),
      use.names = FALSE,
      recursive = TRUE)
  }
}

stri_locate_all_regex_no_stri <- function(str, pattern) {
  row_has_pattern <- grepl(pattern, str, perl = TRUE)
  ans <-
    lapply(seq_along(str), function(i) {
      if (row_has_pattern[i]) {
        gregexprs <-
          gregexpr(pattern = pattern,
                   text = str[i],
                   perl = TRUE)
        nchar_pattern <- attr(gregexprs[[1L]], "match.length")[1L]
        out <- matrix(NA_integer_, nrow = length(gregexprs[[1L]]), ncol = 2L)
        for (j in seq_along(gregexprs[[1L]])) {
          out[j, 1L] <- gregexprs[[1L]][j]
        }
        out[, 2L] <- out[, 1L] + nchar_pattern - 1L
        # Conformance with stringi
      } else {
        out <- matrix(NA_integer_, nrow = 1L, ncol = 2L)
      }
      setattr(out, "dimnames", value = list(NULL, c("start", "end")))
      out
    })
  ans
}




