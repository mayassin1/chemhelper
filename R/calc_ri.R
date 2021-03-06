#' Calculate a single Van Den Dool and Kratz Retention Index
#'
#' @param rt The retention time of the compound
#' @param alkanesRT A vector of retention times of alkanes, in descending order
#' @param C_num A vector of the numbers of carbons for each of the alkanes
#'
#' @return A retention index
#'
#'
VDDK_RI <-
  function(rt, alkanesRT, C_num){
    if(length(alkanesRT) != length(C_num)){
      stop("Supplied alkaneRT and C_num must be equal length")
    }else if(rt == 0){
      return(NA)
    }else{
      leng = length(alkanesRT)
      n_int = findInterval(rt, alkanesRT)
      if(n_int == 0){
        warning("Compound RT is earlier than that of smallest alkane.")
        n_pos = 1
      }else if(n_int == leng){
        warning("Compound RT is later than that of largest alkane.")
        n_pos = leng - 1
      }else{
        n_pos = n_int
      }
      t_n = alkanesRT[n_pos]
      n = C_num[n_pos]
      t_N = alkanesRT[n_pos + 1]
      RI = 100 * (n + (rt - t_n)/(t_N - t_n))
      return(RI)
    }
  }


#' Calculate a single retention time given a Van Den Dool and Kratz RI
#'
#' @param ri The retention index of the compound
#' @param alkanesRT A vector of retention times of alkanes, in descending order
#' @param C_num A vector of the numbers of carbons for each of the alkanes
#'
#' @return a retention time
#'
#'
VDDK_RT <- function(ri, alkanesRT, C_num){
  if(length(alkanesRT) != length(C_num)){
    stop("Supplied alkaneRT and C_num must be equal length")
  }else{
    leng = length(alkanesRT)
    n_int = findInterval(ri, C_num * 100)
    if(n_int == 0){
      warning("Compound RI is earlier than that of smallest alkane.")
      n_pos = 1
    }else if(n_int == leng){
      warning("Compound RI is later than that of largest alkane.")
      n_pos = leng - 1
    }else{
      n_pos = n_int
    }
    t_n = alkanesRT[n_pos]
    n = C_num[n_pos]
    t_N = alkanesRT[n_pos + 1]
    RT = t_n + ((ri/100) - n) * (t_N - t_n)
  }
}

#' Calculate Van Den Dool and Kratz Retention Indicies
#' 
#' @description This function calculates retention indices using the Van Den Dool and Kratz [equation](https://webbook.nist.gov/chemistry/gc-ri/)
#'
#' @param rts A vector of retention times to be converted to retention indices
#' @param alkanesRT A vector of retention times of standard alkanes, in descending order
#' @param C_num A vector of the numbers of carbons for each of the alkanes
#'
#' @return A vector of retention indices
#' @export
#' @seealso \code{\link{calc_RT}}
#' @examples
#' alkanes <- data.frame(RT = c(1.88, 2.23, 5.51, 8.05, 10.99,
#'                              14.10, 17.20, 20.20, 22.90, 25.60,
#'                              28.10, 30.50, 32.81, 35.22, 37.30),
#'                       C_num = 6:20)
#' calc_RI(11.237, alkanes$RT, alkanes$C_num)
#' 
calc_RI <- function(rts, alkanesRT, C_num){
  sapply(rts, VDDK_RI, alkanesRT = alkanesRT, C_num = C_num, simplify = TRUE)
}



#' Back-calculate Retention Times
#'
#' @description This function back-calculates expected retention times given a Van Den Dool and Kratz [retention index](https://webbook.nist.gov/chemistry/gc-ri/)
#'
#' @param ris A vector of retention indices used to estimate retention times
#' @param alkanesRT A vector of retention times of standard alkanes, in descending order
#' @param C_num A vector of the numbers of carbons for each of the alkanes
#'
#' @return A vector of expected retention times
#' @export
#' @seealso \code{\link{calc_RI}}
#' @examples
#' alkanes <- data.frame(RT = c(1.88, 2.23, 5.51, 8.05, 10.99,
#'                              14.10, 17.20, 20.20, 22.90, 25.60,
#'                              28.10, 30.50, 32.81, 35.22, 37.30),
#'                       C_num = 6:20)
#' calc_RT(1007.942, alkanes$RT, alkanes$C_num)
#' 
calc_RT <- function(ris, alkanesRT, C_num){
  sapply(ris, VDDK_RT, alkanesRT = alkanesRT, C_num = C_num, simplify = TRUE)
}
