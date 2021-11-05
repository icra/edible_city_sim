#!/bin/sh
#SBATCH -ntasks=1
#SBATCH -tasks-per-node=1
#SBATCH -partition=ladon
#SBATCH -cpus-per-task=11

seq=(0 1 2 3 4 5 6 7 8 9 10 11)
names=("BAU" "S1" "S2.0" "S2.25" "S2.50" "S2.75" "S2.100" "S3.0" "S3.25" "S3.50" "S3.75" "S3.100")
pGarden=(0 1 1 1 1 1 1 1 1 1 1 1)
pVacant=(0 0 1 1 1 1 1 1 1 1 1 1)
pRooftop=(0 0 0 0 0 0 0 1 1 1 1 1)
pCommercial=(0.00 0.00 0.00 0.25 0.50 0.75 1.00 0.00 0.25 0.50 0.75 1.00)

spack load r

for i in ${!seq[*]}
do
  echo "${names[$i]} starts"
  Rscript estimate_scenarios_cluster.R ${names[$i]} ${pGarden[$i]} ${pVacant[$i]} ${pRooftop[$i]} ${pCommercial[$i]}
  echo "${names[$i]} ends"
done