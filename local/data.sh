set -e
set -u
set -o pipefail

log() {
    local fname=${BASH_SOURCE[1]##*/}
    echo -e "$(date '+%Y-%m-%dT%H:%M:%S') (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $*"
}
SECONDS=0

stage=0
stop_stage=2

log "$0 $*"
. utils/parse_options.sh

if [ $# -ne 0 ]; then
    log "Error: No positional arguments are required."
    exit 2
fi

. ./path.sh || exit 1;
. ./cmd.sh || exit 1;
. ./db.sh || exit 1;

if [ -z "${TEST_COPY}" ]; then
   log "Fill the value of 'TEST' of db.sh"
   exit 1
fi
db_root=${TEST_COPY}

train_set=tr_no_dev
train_dev=dev
eval_set=eval1

if [ ${stage} -le 0 ] && [ ${stop_stage} -ge 0 ]; then
    log "stage 0: Data Preparation"
    # set filenames
    scp=data/train/wav.scp
    utt2spk=data/train/utt2spk
    spk2utt=data/train/spk2utt
    text=data/train/text

    # check file existence
    [ ! -e data/train ] && mkdir -p data/train
    [ -e ${scp} ] && rm ${scp}
    [ -e ${utt2spk} ] && rm ${utt2spk}
    [ -e ${spk2utt} ] && rm ${spk2utt}
    [ -e ${text} ] && rm ${text}

    # make scp, utt2spk, and spk2utt
    find ${db_root}/testScripts -follow -name "*.wav" | sort | while read -r filename;do
        id=$(basename ${filename} | sed -e "s/\.[^\.]*$//g")
        echo "${id} ${filename}" >> ${scp}
        echo "${id} TEST" >> ${utt2spk}
    done
    utils/utt2spk_to_spk2utt.pl ${utt2spk} > ${spk2utt}

    # make text usign the original text
    # cleaning and phoneme conversion are performed on-the-fly during the training
    paste -d " " \
        <(cut -d "|" -f 1 < ${db_root}/testScripts/metadata.csv) \
        <(cut -d "|" -f 3 < ${db_root}/testScripts/metadata.csv) \
        > ${text}

    utils/fix_data_dir.sh data/train
    utils/validate_data_dir.sh --no-feats data/train
fi

if [ ${stage} -le 1 ] && [ ${stop_stage} -ge 1 ]; then
    log "stage 2: utils/subset_data_dir.sg"
    # make evaluation and devlopment sets
    utils/subset_data_dir.sh --last data/train 20 data/deveval
    utils/subset_data_dir.sh --last data/deveval 10 data/${eval_set}
    utils/subset_data_dir.sh --first data/deveval 10 data/${train_dev}
    n=$(( $(wc -l < data/train/wav.scp) - 20 ))
    utils/subset_data_dir.sh --first data/train ${n} data/${train_set}
fi

log "Successfully finished. [elapsed=${SECONDS}s]"
