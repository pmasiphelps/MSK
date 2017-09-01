library("xlsx")
library(dplyr)
train = read.csv('./Original_Data/training_variants')
test = read.csv('./Original_Data/test_variants')

sapply(train, class)
sapply(test, class)


train = train %>% mutate(.,Variation = as.character(Variation))
test = test %>% mutate(.,Variation = as.character(Variation))

train_aa = train %>% mutate(.,original_AA = ifelse(Variation == toupper(Variation),substr(Variation,0,1),0)) %>% 
  mutate(.,mutate_AA = ifelse(Variation == toupper(Variation),substr(Variation,nchar(Variation),nchar(Variation)),0))
test_aa = test %>% mutate(.,original_AA = ifelse(Variation == toupper(Variation),substr(Variation,0,1),0)) %>% 
  mutate(.,mutate_AA = ifelse(Variation == toupper(Variation),substr(Variation,nchar(Variation),nchar(Variation)),0))

#Load in amino acid excel data on hydropathy and charge (as Isoelectric point)
aa_prop <- read.xlsx("Amino_Acids.xlsx", 1 , stringsAsFactors=F)

#Preparing data for left_joins with Charge Data; Rename columns
aa = aa_prop %>% select(.,-Amino.Acid, -Hydrophobicity)
bb = aa_prop %>% select(.,-Isoelectric_P, -Amino.Acid)
View(bb)
train_aa_charge = left_join(train_aa, aa, by = c("original_AA" = "Letter"))
test_aa_charge = left_join(test_aa, aa, by = c("original_AA" = "Letter"))

View(train_aa_charge)
View(test_aa_charge)

train_aa_charge = train_aa_charge %>% mutate(.,IP1 = Isoelectric_P) %>% select(.,-Isoelectric_P)
train_aa_charge = left_join(train_aa_charge,aa, by = c('mutate_AA' = 'Letter')) %>% mutate(.,IP2 = Isoelectric_P) 
train_aa_charge = train_aa_charge %>% select(.,-Isoelectric_P)

test_aa_charge = test_aa_charge %>% mutate(.,IP1 = Isoelectric_P) %>% select(.,-Isoelectric_P)
test_aa_charge = left_join(test_aa_charge,aa, by = c('mutate_AA' = 'Letter')) %>% mutate(.,IP2 = Isoelectric_P) 
test_aa_charge = test_aa_charge %>% select(.,-Isoelectric_P)

#Remove cases in which it is unclear what the ultimate mutation is (*)
for (row in 1:nrow(train_aa_charge)){
  if (train_aa_charge[row,6] == '*'){
    train_aa_charge[row,7:8] = 0
  }
}

for (row in 1:nrow(test_aa_charge)){
  if (test_aa_charge[row,6] == '*'){
    test_aa_charge[row,7:8] = 0
  }
}

#Convert all NAs to zero
train_aa_charge[is.na(train_aa_charge)] <- 0
test_aa_charge[is.na(train_aa_charge)] <- 0

#Preparing data for addition of hydropathy data
train_aa_hydro = left_join(train_aa_charge, bb, by = c("original_AA" = "Letter"))
test_aa_hydro = left_join(test_aa_charge, bb, by = c("original_AA" = "Letter"))

View(train_aa_hydro)
View(test_aa_hydro)

train_aa_hydro = train_aa_hydro %>% mutate(.,H1 = Hydrophobicity) %>% select(.,-Hydrophobicity)
train_aa_hydro = left_join(train_aa_hydro,bb, by = c('mutate_AA' = 'Letter')) %>% 
  mutate(.,H2 = Hydrophobicity) %>% select(.,-Hydrophobicity)

test_aa_hydro = test_aa_hydro %>% mutate(.,H1 = Hydrophobicity) %>% select(.,-Hydrophobicity)
test_aa_hydro = left_join(test_aa_hydro,bb, by = c('mutate_AA' = 'Letter')) %>% 
  mutate(.,H2 = Hydrophobicity) %>% select(.,-Hydrophobicity)

#Remove cases in which it is unclear what the ultimate mutation is (*)
for (row in 1:nrow(train_aa_hydro)){
  if (train_aa_hydro[row,6] == '*'){
    train_aa_hydro[row,9:10] = 0
  }
}

for (row in 1:nrow(test_aa_hydro)){
  if (test_aa_hydro[row,6] == '*'){
    test_aa_hydro[row,9:10] = 0
  }
}

#Convert all NAs to zero
train_aa_hydro[is.na(train_aa_hydro)] <- 0
View(train_aa_hydro)

test_aa_hydro[is.na(test_aa_hydro)] <- 0
View(test_aa_hydro)

#Create new columns that represent absolute differences in hydropathy and charge
train_aa_hydro = train_aa_hydro %>% mutate(.,IP1 = as.numeric(IP1),IP2 = as.numeric(IP2),
                                           H1 = as.numeric(H1),H2 = as.numeric(H2))
test_aa_hydro = test_aa_hydro %>% mutate(.,IP1 = as.numeric(IP1),IP2 = as.numeric(IP2),
                                           H1 = as.numeric(H1),H2 = as.numeric(H2))

#Calculate absolute value differences in electrical/hydropathy values for original -> mutation amino acids
train_aa_extra = train_aa_hydro %>% mutate(.,elec_diff = abs(IP1-IP2),hydro_diff = abs(H1-H2)) %>% 
  select(.,-IP1,-IP2,-H1,-H2)
test_aa_extra = test_aa_hydro %>% mutate(.,elec_diff = abs(IP1-IP2),hydro_diff = abs(H1-H2)) %>% 
  select(.,-IP1,-IP2,-H1,-H2)

#Final dataframe is called train_aa_extra; write to a CSV
View(train_aa_extra)
write.csv(train_aa_extra, "train_aa_extra.csv")
write.csv(test_aa_extra, "test_aa_extra.csv")


