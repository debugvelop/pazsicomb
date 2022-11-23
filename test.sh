#!/bin/bash

#Get the VM instance's name as the folder name
folderName=$(curl --header "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/name)

#Run the test in 4 sessions with different numbers of parallel build.
for session in 5 10 20 40; do
    #Repeat each session 3 times to minimize random fluctuation
    for set in 1 2 3; do
        echo "Build ${session} images parallel. Iteration #${set}"
        echo "Reset the Docker"
        docker system prune -a -f
        #Start the glances
        echo "Monitoring start"
        glances --export csv --export-csv-file "perflog-${session}-${set}.csv" --quiet &
        #Start the build
        echo "Building start"
        (time skaffold build --build-concurrency=$session) 2> "buildtime-${session}-${set}.txt"
        #Stop the glances
        echo "Monitoring stop"
        pkill glances
        echo "Uploading logs to the GCS bucket"
        gsutil cp "perflog-${session}-${set}.csv" "buildtime-${session}-${set}.txt" "gs://researchlog/${folderName}/"
    done
done