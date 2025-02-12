% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predict_spatial.R
\name{predict_spatial}
\alias{predict_spatial}
\title{Predict on spatial objects with mlr3 learners}
\usage{
predict_spatial(
  task,
  learner,
  chunksize = 200L,
  format = "terra",
  filename = NULL
)
}
\arguments{
\item{task}{(\link{Task}).}

\item{learner}{(\link{Learner}).}

\item{chunksize}{\verb{[integer]}\cr
The chunksize determines in how many subparts the prediction task will be
split into. The value can be roughly thought of as megabyte of a raster file
on disk. For example, if a prediction on a 1 GB file would be carried out
with \code{chunksize = 100L}, the prediction would happen in 10 chunks.

The default of \code{chunksize = 1000L} might be a good compromise between speed
and memory usage. If you find yourself running out of memory, reduce this
value.}

\item{format}{\verb{[character]}\cr
Output class of the resulting object. Accepted values are \code{"raster"},
\code{"stars"} and \code{"terra"} if the input is a \link{DataBackendRaster}. Note that when
choosing something else than \code{"terra"}, the spatial object is converted into
the respective format which might cause overhead both in runtime and memory
allocation.
For a \link{DataBackendVector}, the output class will always be \link[sf:sf]{sf::sf}.}

\item{filename}{\verb{[character]}\cr
Path where the spatial object should be written to.}
}
\value{
Spatial object of class given in argument \code{format}.
}
\description{
This function allows to directly predict mlr3 learners on
various spatial objects (see section "Supported Spatial Classes"). It returns
an \link[mlr3:Prediction]{mlr3::Prediction} object and (optionally) the same object that was used
for the prediction.
}
\details{
When parallelizing the prediction via {future}, plan \code{"multisession"} will
not work due to external pointers within the spatial object. If the execution
platform is UNIX-based, \code{plan("multicore")} is recommended. For Windows
users, \code{plan(future.callr::callr)} might be an alternative.
}
\examples{
stack = demo_stack_spatraster(size = 1)
value = data.table::data.table(ID = c(0, 1), y = c("negative", "positive"))
terra::setCats(stack, layer = "y", value = value)

# create backend
backend = as_data_backend(stack)
task = as_task_classif(backend, target = "y", positive = "positive")
# train
learner = lrn("classif.featureless")
learner$train(task, row_ids = sample(1:task$nrow, 50))
ras = predict_spatial(task, learner)
ras
}
