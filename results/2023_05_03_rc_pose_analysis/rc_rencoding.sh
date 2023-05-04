
#!/bin/bash
input_directory=/nancy/projects/reward_competition_ephys_analysis_with_omission_and_divider_controls/data/good

for full_path in ${input_directory}/*/*/*.mp4; do
    echo Currently working on: ${full_path}
    dir_name=$(dirname ${full_path})
    file_name=${full_path##*/}
    base_name="${file_name%.mp4}"

    echo Directory: ${dir_name}
    echo File Name: ${file_name}
    echo Base Name: ${base_name}

    ffmpeg -y -i ${full_path} -c:v libx264 -pix_fmt yuv420p -preset superfast -crf 23 ${dir_name}/${base_name}.fixed.mp4

done


echo All Done!


