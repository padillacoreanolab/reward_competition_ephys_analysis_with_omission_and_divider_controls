#!/bin/bash
project_dir=/nancy/projects/reward_competition_ephys_analysis_with_omission_and_divider_controls/results/2023_05_17_sleap_analysis
cd ${project_dir}

model_directory=${project_dir}/models/baseline_medium_rf.bottomup

video_directory=${project_dir}/data/reencoded_videos

# Inference
echo "inference ${video_directory}"
for full_path in ${video_directory}/*.mp4; do
    echo ${full_path}

    dir_name=$(dirname ${full_path})
    file_name=${full_path##*/}
    base_name="${file_name%.mp4}"

    sleap-track ${full_path} --tracking.tracker flow \
    --tracking.similarity iou --tracking.match greedy \
    --tracking.clean_instance_count 2 \
    --tracking.target_instance_count 2 \
    -m ${model_directory} \
    -o ${project_dir}/proc/predicted_frames/2_subj/${base_name}.2_subj.predictions.slp
done

# Rendering
echo "rendering ${video_directory}"
for full_path in ${project_dir}/proc/predicted_frames/2_subj/*.predictions.slp; do
    echo ${full_path}
    sleap-render ${full_path}
done

echo All Done!