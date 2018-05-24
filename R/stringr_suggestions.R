
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
  if (is.matrix(start)) {
    stri_sub(string, from = start, omit_na = omit_na) <- value
  }
  else {
    stri_sub(string, from = start, to = end, omit_na = omit_na) <- value
  }
  string
}





