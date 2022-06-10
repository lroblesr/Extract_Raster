# install.packages("pacman", dep = T)
pacman::p_load(raster, rgdal, dplyr, rstudioapi)

# Change the work directory to the folder containing the script
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Director Tree suggestion
# data/
  # input/
    # raster/
      # data.tif
    # shapefile/
      # shp.shp
  # output/

path_raster_file <- "data/input/raster/Tile01.tif"
path_shape_file <- "data/input/shapefile/sample1.shp"
name_save        <- "Extract_01" # only name

# Read raster Index
Index <- raster(path_raster_file)
# class(Index)
# dim(Index)

# Read shape file
shp <- path_shape_file %>% readOGR() %>%
        spTransform(CRSobj = crs(Index))
# dim(shp)
# View(shp@data)

# plot(Index)
# plot(shp, add = T)

extract_dat <- Index %>%
                extract(shp,
                        df = TRUE,
                        weights = TRUE,
                        normalizeWeights = TRUE) %>%
                `colnames<-`(c('ID', 'Index', 'Weight'))
# View(extract_dat)

write.csv(extract_dat, file = paste0("data/output/", nombre_save, "_org_con_peso.csv"))

summer <- extract_dat %>%
                group_by(ID) %>%
                summarise(
                        mean = mean(Index),
                        median = median(Index),
                        min = min(Index),
                        max = max(Index),
                        sd = sd(Index),
                        var = var(Index),
                        count = n()
                )
# View(summer)

write.csv(summer, file = paste0('data/output/', nombre_save, '_estadistico.csv'))
