#!/bin/bash
set -e

# ============================================================
# PATHS
# ============================================================

# Dorado binary
DORADO="$HOME/tools/dorado-1.3.1-linux-x64/bin/dorado"

# Dorado model directory
export DORADO_MODELS_DIR="/DATA4/amishi/dorado_models"

# Input POD5 files
POD5_DIR="/DATA4/amishi/pod5_files"

# Output directory
OUTPUT_DIR="/DATA4/amishi/dorado_sup_outputs"

# Reference genome
REFERENCE="/DATA4/amishi/reference.fasta"

# ============================================================
# MODELS
# ============================================================

# SUP basecalling model
BASE_MODEL="dna_r10.4.1_e8.2_400bps_sup@v5.0.0"

# SUP methylation model
METHYL_MODEL="dna_r10.4.1_e8.2_400bps_sup@v5.0.0_5mCG_5hmCG@v3"

# ============================================================
# CREATE OUTPUT DIRECTORY
# ============================================================

mkdir -p "$OUTPUT_DIR"

echo "=================================================="
echo "Starting Dorado SUP methylation calling"
echo "=================================================="
echo "POD5 directory : $POD5_DIR"
echo "Output directory: $OUTPUT_DIR"
echo "Reference       : $REFERENCE"
echo

# ============================================================
# MAIN LOOP
# ============================================================

for pod5 in "$POD5_DIR"/*.pod5; do

    [ -e "$pod5" ] || continue

    name=$(basename "$pod5" .pod5)

    echo "=================================================="
    echo "Processing: $name"
    echo "=================================================="

    SORTED_BAM="$OUTPUT_DIR/${name}_sup_methylation.sorted.bam"

    "$DORADO" basecaller \
        "$BASE_MODEL" \
        "$pod5" \
        --modified-bases-models "$METHYL_MODEL" \
        --reference "$REFERENCE" \
        --min-qscore 9 \
        --emit-moves \
    | samtools sort -@ 8 -o "$SORTED_BAM"

    # ========================================================
    # INDEX BAM
    # ========================================================

    samtools index "$SORTED_BAM"

    # ========================================================
    # VERIFY MM/ML TAGS
    # ========================================================

    MM_CHECK=$(samtools view "$SORTED_BAM" \
        | head -5 \
        | grep -c "MM:Z:" || true)

    if [ "$MM_CHECK" -gt 0 ]; then
        echo "✓ MM/ML methylation tags confirmed for $name"
    else
        echo "WARNING: MM/ML tags not found for $name"
    fi

    echo "✓ Finished: $name"
    echo

done

echo "=================================================="
echo "All POD5 files processed successfully!"
echo "=================================================="