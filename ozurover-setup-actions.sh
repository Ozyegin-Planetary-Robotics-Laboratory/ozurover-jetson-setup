# Setup GitHub Actions Runner
echo "Setting up GitHub Actions Runner..."
user_id=`id -u`
if [ $user_id -eq 0 -a -z "$RUNNER_ALLOW_RUNASROOT" ]; then
    echo "Must not run with sudo"
    exit 1
fi
cd ~ || exit
gh_token=`cat ~/github_token`
mkdir actions-runner
cd actions-runner || exit
sudo ./bin/installdependencies.sh
curl -o actions-runner-linux-arm64-2.276.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.276.1/actions-runner-linux-arm64-2.276.1.tar.gz
tar xzf ./actions-runner-linux-arm64-2.276.1.tar.gz
./config.sh --url https://github.com/Ozyegin-Planetary-Robotics-Laboratory --token $gh_token --unattended
sudo ./svc.sh install "$USER"
sudo ./svc.sh start