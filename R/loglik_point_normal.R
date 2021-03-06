# Functions to compute the log likelihood under the normal prior.

loglik_point_normal = function(x, s, w, a, mu) {
  sum(vloglik_point_normal(x, s, w, a, mu))
}

# Return log((1 - w)f + wg) as a vector (deal with cases w = 1 and w = 0
#   separately for stability).
#
#' @importFrom stats dnorm
#'
vloglik_point_normal = function(x, s, w, a, mu) {
  if (w <= 0) {
    return(dnorm(x, mu, s, log = TRUE))
  }

  lg <- dnorm(x, mu, sqrt(s^2 + 1/a), log = TRUE)
  if (w >= 1) {
    return(lg)
  }

  lf <- dnorm(x, mu, s, log = TRUE)
  lfac <- pmax(lg, lf)
  result <- lfac + log((1 - w) * exp(lf - lfac) + w * exp(lg - lfac))

  # Deal with zero sds:
  result[s == 0 & x == mu] <- log(1 - w)
  result[s == 0 & x != mu] <- log(w) + lg[s == 0 & x != mu]

  return(result)
}
