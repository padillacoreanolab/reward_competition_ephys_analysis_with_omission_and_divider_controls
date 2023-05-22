#!/bin/bash
project_dir=/nancy/projects/reward_competition_ephys_analysis_with_omission_and_divider_controls
experiment_dir=${project_dir}/results/2023_05_17_sleap_analysis

round_number=round_5

cd ${experiment_dir}

model_directory=${experiment_dir}/models/${round_number}/baseline_medium_rf.bottomup

echo "training with model ${model_directory}"
sleap-train ${experiment_dir}/scripts/${round_number}/baseline_medium_rf.bottomup.json \
${experiment_dir}/proc/labeled_frames/${round_number}/rc_om_and_comp_combined.fixed.mp4.labeled.round_5.pkg.pkg.slp

video_directory=${project_dir}/data/good

# Inference
echo "inference ${video_directory}"
for full_path in ${video_directory}/*/*fixed.mp4; do
    echo ${full_path}

    dir_name=$(dirname ${full_path})
    file_name=${full_path##*/}
    base_name="${file_name%.mp4}"

    sleap-track ${full_path} --tracking.tracker flow \
    --tracking.similarity iou --tracking.match greedy \
    --tracking.clean_instance_count 2 \
    --tracking.target_instance_count 2 \
    -m ${model_directory} \
    -o ${experiment_dir}/proc/predicted_frames/${round_number}/${base_name}.2_subj.${round_number}.predicted_frames.slp

   sleap-track ${full_path} --tracking.tracker flow \
    --tracking.similarity iou --tracking.match greedy \
    --tracking.clean_instance_count 1 \
    --tracking.target_instance_count 1 \
    -m ${model_directory} \
    -o ${experiment_dir}/proc/predicted_frames/${round_number}/${base_name}.1_subj.${round_number}.predicted_frames.slp


done

# Rendering
echo "rendering ${video_directory}"
for full_path in ${experiment_dir}/proc/predicted_frames/${round_number}/*.predicted_frames.slp; do
    echo ${full_path}
    sleap-render ${full_path}
done

echo All Done!