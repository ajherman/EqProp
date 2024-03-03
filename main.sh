
#!/bin/bash -l

#SBATCH --job-name=main
#SBATCH --time 10:00:00
#SBATCH -N 6
#SBATCH -p shared-gpu
#module load miniconda3
#source activate /vast/home/ajherman/miniconda3/envs/pytorch

epochs=25
cores=20

# Accumulator neuron experiments
T1=8
T2=3
#tau_dynamic=0.2

# step=0.02 # Keep fixed
step=0.2
batch_size=20
omega=1

# for omega in {1,4,16,64,256,1024}
for lr1 in {0.0028,0.0056,0.01}
do
for lr2 in {0.0028,0.0056,0.01}
do
for lr3 in {0.0028,0.0056,0.01}
do
for hidden_size1 in {128,256,384}
do
for hidden_size2 in {128,256,384}
do
for tau_dynamic in {0.1,0.2,0.4}
do
for beta in {0.1,0.2,0.4}
stdp0_dir=compare_stdp0_omega_"$omega"_tau_"$tau_dynamic"_h1_"$hidden_size1"_h2_"$hidden_size2"_lr1_"$lr1"_lr2_"$lr2"_lr3_"$lr3"_beta_"$beta"
stdp1_dir=compare_stdp1_omega_"$omega"_tau_"$tau_dynamic"_h1_"$hidden_size1"_h2_"$hidden_size2"_lr1_"$lr1"_lr2_"$lr2"_lr3_"$lr3"_beta_"$beta"
stdp2_dir=compare_stdp2_omega_"$omega"_tau_"$tau_dynamic"_h1_"$hidden_size1"_h2_"$hidden_size2"_lr1_"$lr1"_lr2_"$lr2"_lr3_"$lr3"_beta_"$beta"
stdp3_dir=compare_stdp3_omega_"$omega"_tau_"$tau_dynamic"_h1_"$hidden_size1"_h2_"$hidden_size2"_lr1_"$lr1"_lr2_"$lr2"_lr3_"$lr3"_beta_"$beta"
# stdp4_dir=compare_stdp4_omega_"$omega"_tau_"$tau_dynamic"_h1_"$hidden_size1"_h2_"$hidden_size2"_lr1_"$lr1"_lr2_"$lr2"_lr3_"$lr3"_beta_"$beta"
# stdp5_dir=compare_stdp5_omega_"$omega"_tau_"$tau_dynamic"_h1_"$hidden_size1"_h2_"$hidden_size2"_lr1_"$lr1"_lr2_"$lr2"_lr3_"$lr3"_beta_"$beta"

mkdir -p $stdp0_dir
mkdir -p $stdp1_dir
mkdir -p $stdp2_dir
mkdir -p $stdp3_dir
# mkdir -p $stdp4_dir
# mkdir -p $stdp5_dir

srun -N 1 -n 1 -c $cores -o "$stdp0_dir".out --open-mode=append ./main_wrapper.sh --M 1 --spiking --load --use-time-variables --directory $stdp0_dir --omega $omega --step $step --spike-method poisson --tau-dynamic $tau_dynamic --tau-trace 0.025 --action train --batch-size $batch_size --activation-function hardsigm --size_tab 10 $hidden_size1 $hidden_size2 784 --lr_tab $lr1 $lr2 $lr3 --epochs $epochs --T1 $T1 --T2 $T2 --beta $beta --cep --learning-rule stdp --update-rule stdp &
srun -N 1 -n 1 -c $cores -o "$stdp1_dir".out --open-mode=append ./main_wrapper.sh --M 1 --spiking --load --use-time-variables --directory $stdp1_dir --omega $omega --step $step --spike-method poisson --tau-dynamic $tau_dynamic --tau-trace 0.05 --action train --batch-size $batch_size --activation-function hardsigm --size_tab 10 $hidden_size1 $hidden_size2 784 --lr_tab $lr1 $lr2 $lr3 --epochs $epochs --T1 $T1 --T2 $T2 --beta $beta --cep --learning-rule stdp --update-rule stdp &
srun -N 1 -n 1 -c $cores -o "$stdp2_dir".out --open-mode=append ./main_wrapper.sh --M 1 --spiking --load --use-time-variables --directory $stdp2_dir --omega $omega --step $step --spike-method poisson --tau-dynamic $tau_dynamic --tau-trace 0.1 --action train --batch-size $batch_size --activation-function hardsigm --size_tab 10 $hidden_size1 $hidden_size2 784 --lr_tab $lr1 $lr2 $lr3 --epochs $epochs --T1 $T1 --T2 $T2 --beta $beta --cep --learning-rule stdp --update-rule stdp &
srun -N 1 -n 1 -c $cores -o "$stdp3_dir".out --open-mode=append ./main_wrapper.sh --M 1 --spiking --load --use-time-variables --directory $stdp3_dir --omega $omega --step $step --spike-method poisson --tau-dynamic $tau_dynamic --tau-trace 0.2 --action train --batch-size $batch_size --activation-function hardsigm --size_tab 10 $hidden_size1 $hidden_size2 784 --lr_tab $lr1 $lr2 $lr3 --epochs $epochs --T1 $T1 --T2 $T2 --beta $beta --cep --learning-rule stdp --update-rule stdp &
# srun -N 1 -n 1 -c $cores -o "$stdp4_dir".out --open-mode=append ./main_wrapper.sh --M 1 --spiking --load --use-time-variables --directory $stdp4_dir --omega $omega --step $step --spike-method poisson --tau-dynamic $tau_dynamic --tau-trace 0.4 --action train --batch-size $batch_size --activation-function hardsigm --size_tab 10 $hidden_size1 $hidden_size2 784 --lr_tab $lr1 $lr2 $lr3 --epochs $epochs --T1 $T1 --T2 $T2 --beta $beta --cep --learning-rule stdp --update-rule stdp &
# srun -N 1 -n 1 -c $cores -o "$stdp5_dir".out --open-mode=append ./main_wrapper.sh --M 1 --spiking --load --use-time-variables --directory $stdp5_dir --omega $omega --step $step --spike-method poisson --tau-dynamic $tau_dynamic --tau-trace 0.8 --action train --batch-size $batch_size --activation-function hardsigm --size_tab 10 $hidden_size1 $hidden_size2 784 --lr_tab $lr1 $lr2 $lr3 --epochs $epochs --T1 $T1 --T2 $T2 --beta $beta --cep --learning-rule stdp --update-rule stdp &
done
done
done
done
done
done
