package common

import (
	"context"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/codebuild"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestDoesCodebuildProjectExist(t *testing.T, ctx types.TestContext) {
	codebuildClient := codebuild.NewFromConfig(GetAWSConfig(t))
	projectNames := terraform.OutputList(t, ctx.TerratestTerraformOptions(), "project_name")
	projectIDs := terraform.OutputList(t, ctx.TerratestTerraformOptions(), "project_id")
	projects, err := codebuildClient.BatchGetProjects(context.TODO(), &codebuild.BatchGetProjectsInput{Names: projectNames})
	if err != nil {
		t.Errorf("Error getting projects %s: %v", projectNames, err)
	}

	t.Run("TestDoesProjectExist", func(t *testing.T) {
		require.Equal(t, 2, len(projects.Projects), "Expected to find 2 projects with names %s, but found %d", projectNames, len(projects.Projects))
		require.Equal(t, projectIDs[0], *projects.Projects[0].Arn, "Expected project ID to be %s, but got %s", projectIDs[0], *projects.Projects[0].Arn)
		require.Equal(t, projectIDs[1], *projects.Projects[1].Arn, "Expected project ID to be %s, but got %s", projectIDs[1], *projects.Projects[1].Arn)
	})

	t.Run("TestDoBuildsComplete", func(t *testing.T) {
		// Start builds for both projects
		build0, err := codebuildClient.StartBuild(context.TODO(), &codebuild.StartBuildInput{ProjectName: &projectNames[0]})
		if err != nil {
			t.Errorf("Error starting build for project %s: %v", projectNames[0], err)
		}
		build1, err := codebuildClient.StartBuild(context.TODO(), &codebuild.StartBuildInput{ProjectName: &projectNames[1]})
		if err != nil {
			t.Errorf("Error starting build for project %s: %v", projectNames[1], err)
		}

		// Wait for builds to complete
		var builds *codebuild.BatchGetBuildsOutput
		buildIds := []string{*build0.Build.Id, *build1.Build.Id}
		for builds, err = GetBuildStatus(codebuildClient, buildIds); len(builds.Builds) > 0 && err == nil; builds, err = GetBuildStatus(codebuildClient, buildIds) {
			if string((*builds).Builds[0].BuildStatus) == "SUCCEEDED" && string((*builds).Builds[1].BuildStatus) == "SUCCEEDED" {
				break
			}
			if string((*builds).Builds[0].BuildStatus) == "IN_PROGRESS" || string((*builds).Builds[1].BuildStatus) == "IN_PROGRESS" {
				time.Sleep(10 * time.Second)
				t.Logf("Waiting for builds %s and %s to complete", *build0.Build.Id, *build1.Build.Id)
				continue
			}
			break
		}
		if err != nil {
			t.Errorf("Error getting status for builds %s and %s: %v", *build0.Build.Id, *build1.Build.Id, err)
		}

		// Verify builds completed successfully (use "assert" instead of "require" so we can see all statuses)
		assert.Equal(t, "SUCCEEDED", string((*builds).Builds[0].BuildStatus), "Expected build for project %s to succeed, but got %s", projectNames[0], string((*builds).Builds[0].BuildStatus))
		require.Equal(t, "SUCCEEDED", string((*builds).Builds[1].BuildStatus), "Expected build for project %s to succeed, but got %s", projectNames[1], string((*builds).Builds[1].BuildStatus))
	})
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}

func GetBuildStatus(client *codebuild.Client, buildIds []string) (builds *codebuild.BatchGetBuildsOutput, err error) {
	return client.BatchGetBuilds(context.TODO(), &codebuild.BatchGetBuildsInput{Ids: buildIds})
}
