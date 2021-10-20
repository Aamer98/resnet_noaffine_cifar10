#!/bin/bash
#SBATCH --mail-user=ar.aamer@gmail.com
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL
#SBATCH --job-name=noaffine_cifar_new.sh
#SBATCH --output=%x-%j.out
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --ntasks-per-node=32
#SBATCH --mem=127000M
#SBATCH --time=0-06:00
#SBATCH --account=rrg-ebrahimi


nvidia-smi

module load python
source ~/py37/bin/activate



echo "------------------------------------< Data preparation>----------------------------------"
echo "Copying the source code"
date +"%T"
cd $SLURM_TMPDIR
cp -r ~/scratch/resnet_noaffine_cifar10 .


date + "%T"

echo "---------------------------------------<Run the program>------------------------------------"

cd $SLURM_TMPDIR
cd resnet_noaffine_cifar10

for model in resnet20 
do
    echo "python -u trainer_new.py  --arch=$model  --save-dir=save_$model |& tee -a log_$model"
    python -u trainer_new.py  --arch=$model  --save-dir=save_$model |& tee -a log_$model
done


echo "---------------------------------------<End of program>-------------------------------------"

date +"%T"\

cd ..

echo "----------------------------------<Copying files to Scratch>--------------------------------"

date +"%T"\

cp -r ./resnet_noaffine_cifar10 ~/scratch

date +"%T"\