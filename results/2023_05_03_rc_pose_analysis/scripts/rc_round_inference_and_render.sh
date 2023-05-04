#!/bin/bash

repo_dir=/nancy/projects/reward_competition_ephys_analysis_with_omission_and_divider_controls
project_dir=${repo_dir}/results/2023_05_03_rc_pose_analysis
cd ${project_dir}

model_directory=${repo_dir}/results/2023_01_12_rc_sleap/models/round_4_baseline_medium_rf.bottomup
video_directory=${repo_dir}/data/good

# Inference
echo "inference ${video_directory}"
for full_path in ${video_directory}/**/*fixed.mp4; do
    echo ${full_path}

    dir_name=$(dirname ${full_path})
    file_name=${full_path##*/}
    base_name="${file_name%.mp4}"

    sleap-track ${full_path} --tracking.tracker flow \
    --tracking.similarity iou --tracking.match greedy \
    --tracking.clean_instance_count 2 \
    --tracking.target_instance_count 2 \
    -m ${model_directory} \
    -o ${project_dir}/predictions/${base_name}.round_4.predictions.slp
done

# Rendering
echo "rendering ${video_directory}"
for full_path in ${project_dir}/predictions/*.predictions.slp; do
    echo ${full_path}
    sleap-render ${full_path}
done

echo All Done!