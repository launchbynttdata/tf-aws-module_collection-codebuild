package common

import (
	"context"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/codebuild"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/require"
)

func TestDoesCodebuildProjectExist(t *testing.T, ctx types.TestContext) {
	codebuildClient := codebuild.NewFromConfig(GetAWSConfig(t))

	t.Run("TestDoesProjectExist", func(t *testing.T) {
		projectNames := terraform.OutputList(t, ctx.TerratestTerraformOptions(), "project_name")
		projectIDs := terraform.OutputList(t, ctx.TerratestTerraformOptions(), "project_id")
		projects, err := codebuildClient.BatchGetProjects(context.TODO(), &codebuild.BatchGetProjectsInput{Names: projectNames})
		if err != nil {
			t.Errorf("Error getting projects %s: %v", projectNames, err)
		}

		require.Equal(t, 2, len(projects.Projects), "Expected to find 2 projects with names %s, but found %d", projectNames, len(projects.Projects))
		require.Equal(t, projectIDs[0], *projects.Projects[0].Arn, "Expected project ID to be %s, but got %s", projectIDs[0], *projects.Projects[0].Arn)
		require.Equal(t, projectIDs[1], *projects.Projects[1].Arn, "Expected project ID to be %s, but got %s", projectIDs[1], *projects.Projects[1].Arn)
	})
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}
